from datetime import datetime, timedelta, timezone
from aws_xray_sdk.core import xray_recorder

class NotificationsActivities:
  def run():
    segment = xray_recorder.begin_segment("notifications")
    now = datetime.now(timezone.utc).astimezone()
    # xray
    # subsegment = xray_recorder.begin_subsegment('mock-data')
    # dict = {
    #   "now": now.isoformat()
    # }
    # subsegment.put_metadata('key', dict, 'namespace')
    results = [{
      'uuid': '68f126b0-1ceb-4a33-88be-d90fa7109eee',
      'handle':  'K12cantri',
      'message': 'Cloud is not easy and not fun!',
      'created_at': (now - timedelta(days=2)).isoformat(),
      'expires_at': (now + timedelta(days=5)).isoformat(),
      'likes_count': 5,
      'replies_count': 1,
      'reposts_count': 0,
      'replies': [{
        'uuid': '26e12864-1c26-5c3a-9658-97a10f8fea67',
        'reply_to_activity_uuid': '68f126b0-1ceb-4a33-88be-d90fa7109eee',
        'handle':  'Worf',
        'message': 'This post has no honor!',
        'likes_count': 0,
        'replies_count': 0,
        'reposts_count': 0,
        'created_at': (now - timedelta(days=2)).isoformat()
      }],
    }]
    xray_recorder.end_segment
    return results
  
  