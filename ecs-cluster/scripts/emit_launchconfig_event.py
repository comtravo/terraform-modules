#!/usr/bin/env python
"""
  Emit terraform cloudwatch event on launch configuration changes
"""

import argparse
import boto3
import json
import logging as log
import os
import sys

ROOT_DIR = os.path.join(os.path.dirname(__file__), "../../../lib/")
sys.path.append(ROOT_DIR)

from assume_role import get_temporary_credentials
from functools import partial


def color(text, code='37', bold=False):
  """
    colorful logging
    """
  if bold:
    code = "1;%s" % code
  return "\033[%sm%s\033[0m" % (code, text)


red = partial(color, code='31')
green = partial(color, code='32')
yellow = partial(color, code='33')


def err(message):
  """
    error logging
    """
  log.error(red(message))
  exit(1)


def info(message):
  """
    info logging
    """
  log.info(green(message))


def warn(message):
  """
    warn logging
    """
  log.warn(yellow(message))


def parse_cli():
  """
    Parse CLI options
    """
  parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.ArgumentDefaultsHelpFormatter)
  parser.add_argument('--role_to_assume', type=str, help='AWS IAM role to assume', required=True)
  parser.add_argument('--region', type=str, help='AWS region', required=True)
  parser.add_argument('--launch_template_id', type=str, help='AWS launch template id', required=True)
  parser.add_argument('--launch_template_latest_version', type=str, help='AWS launch template version', required=True)
  parser.add_argument('--autoscaling_group_name', type=str, help='AWS autoscaling group name', required=True)
  parser.add_argument('--cluster', type=str, help='AWS ECS cluster name', required=True)
  parser.add_argument('--environment', type=str, help='Environment we are dealing with', required=True)
  parser.add_argument('--log_level', default='INFO', help='logging level', choices=['INFO', 'ERROR', 'WARN'])

  return parser.parse_args()


def apply_cli_options(args):
  """
    Apply CLI options
    """
  log.basicConfig(level=args.log_level, format='[%(asctime)s] %(levelname)s: %(message)s', datefmt='%Y-%m-%d %H:%M:%S')

  return args


def emit_cloudwatch_event(args):
  """
    Emit cloudwatch event
    """

  credentials = get_temporary_credentials(role_to_assume=args.role_to_assume,
                                          region=args.region,
                                          session_name=args.cluster + args.launch_template_id +
                                          args.launch_template_latest_version)

  client = boto3.client('events',
                        region_name=args.region,
                        aws_access_key_id=credentials["AccessKeyId"],
                        aws_secret_access_key=credentials["SecretAccessKey"],
                        aws_session_token=credentials["SessionToken"])

  # AWS API resonses don't have consistent naming schema
  # This event mimicks their response style
  event = {
      'Source':
          'comtravo.terraform.{}'.format(args.environment),
      'Resources': [args.launch_template_id, args.launch_template_latest_version],
      'DetailType':
          'ECS Launch Configuration Change',
      'Detail':
          json.dumps({
              'autoscalingGroupName': args.autoscaling_group_name,
              'clusterArn': args.cluster,
              'agentConnected': False,
              'status': 'ACTIVE'
          })
  }

  try:
    res = client.put_events(Entries=[event])
    if res['FailedEntryCount'] != 0:
      err('Error emitting cloudwatch event: {}. Got response: {}'.format(event, res))
    else:
      info('Event: {} emitted successfully!'.format(event))
      info('Event emitted successfully! with response: {}'.format(res))
  except Exception as _e:
    err('Error emitting cloudwatch event {}. Got error {}'.format(event, _e))


def main():
  """
    main
    """
  args = parse_cli()
  args = apply_cli_options(args)
  emit_cloudwatch_event(args)


if __name__ == "__main__":
  main()
