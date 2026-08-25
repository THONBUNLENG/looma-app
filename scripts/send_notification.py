import firebase_admin
from firebase_admin import credentials, messaging
import sys

def send_push_notification(token, title, body):
    # Path to your service account key
    cred_path = '../android/app/notification-app.json'
    
    try:
        # Initialize Firebase Admin SDK
        cred = credentials.Certificate(cred_path)
        firebase_admin.initialize_app(cred)
        
        # Create a message
        message = messaging.Message(
            notification=messaging.Notification(
                title=title,
                body=body,
            ),
            token=token,
        )
        
        # Send the message
        response = messaging.send(message)
        print(f'Successfully sent message: {response}')
        
    except Exception as e:
        print(f'Error sending message: {e}')

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python send_notification.py <FCM_TOKEN> [title] [body]")
        sys.exit(1)
        
    fcm_token = sys.argv[1]
    msg_title = sys.argv[2] if len(sys.argv) > 2 else "Hello from Looma!"
    msg_body = sys.argv[3] if len(sys.argv) > 3 else "This is a test notification."
    
    send_push_notification(fcm_token, msg_title, msg_body)
