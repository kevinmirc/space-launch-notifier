#!/usr/bin/ruby

# Email notification of the next launch
#
require_relative '../domain/space_launch_notifier' 
require_relative '../notifications/email_notification'

SpaceLaunchNotifier.extend(EmailNotification)
SpaceLaunchNotifier.broadcast!(:next)
