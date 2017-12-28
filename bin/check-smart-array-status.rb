#! /usr/bin/env ruby
# frozen_string_literal: true

#
#   check-smart-array-status
#
# DESCRIPTION:
#   Check HP SmartArray Status Plugin
#
# OUTPUT:
#   plain text
#
# PLATFORMS:
#   Linux
#
# DEPENDENCIES:
#   gem: sensu-plugin
#   gem: open3
#
# USAGE:
#
# NOTES:
#   You can get Debian/Ubuntu hpacucli packages here - http://hwraid.le-vert.net/
#   Checks status for all HDDs in all SmartArray controllers.
#
#   hpacucli requires root permissions.
#   Create a file named /etc/sudoers.d/hpacucli with this line inside :
#   sensu ALL=(ALL) NOPASSWD: /usr/sbin/hpacucli
#
# LICENSE:
#   Copyright 2014 Alexander Bulimov <lazywolf0@gmail.com>
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-plugin/check/cli'
require 'open3'

#
# Check Smart Array Status
#
class CheckSmartArrayStatus < Sensu::Plugin::Check::CLI
  # Setup variables
  #
  def initialize
    super
    @binary = 'sudo -n -k hpacucli'
    @controllers = []
    @good_disks = []
    @bad_disks = []
  end

  # Execute hpacucli and capture the exit status ans stdout
  #
  # @param cmd [String] The command to check the HP array
  def execute(cmd)
    captured_stdout = ''
    # we use popen2e because hpacucli does not use stderr for errors
    exit_status = Open3.popen2e(ENV, cmd) do |stdin, stdout, wait_thr|
      stdin.close
      captured_stdout = stdout.read
      wait_thr.value
    end
    [exit_status, captured_stdout]
  end

  # Parse controller data
  #
  # @param data [String]
  #
  def parse_controllers!(data)
    data.lines.each do |line|
      unless line.empty?
        captures = line.match(/Slot\s+([0-9]+)/)
        @controllers << captures[1] if !captures.nil? && captures.length > 1
      end
    end
  end

  # Parse disk data
  #
  # @param data [String]
  # @param controller [String]
  #
  def parse_disks!(data, controller)
    # #YELLOW
    data.lines.each do |line|
      unless line.empty?
        splitted = line.split
        if splitted.first.match?(/^physicaldrive$/)
          status = splitted[-1]
          disk = 'ctrl ' + controller + ' ' + line.strip
          if status == 'OK'
            @good_disks << disk
          else
            @bad_disks << disk
          end
        end
      end
    end
  end

  # Main function
  #
  def run
    exit_status, raw_data = execute "#{@binary} ctrl all show status"
    unknown "hpacucli command failed - #{raw_data}" unless exit_status.success?
    parse_controllers! raw_data

    @controllers.each do |controller|
      exit_status, raw_data = execute "#{@binary} ctrl slot=#{controller} pd all show status"
      unknown "hpacucli command failed - #{raw_data}" unless exit_status.success?
      parse_disks! raw_data, controller
    end

    if @bad_disks.empty?
      data = @good_disks.length
      ok "All #{data} found disks are OK"
    else
      data = @bad_disks.join(', ')
      bad_count = @bad_disks.length
      good_count = @good_disks.length
      total_count = bad_count + good_count
      critical "#{bad_count} of #{total_count} disks are in bad state - #{data}"
    end
  end
end
