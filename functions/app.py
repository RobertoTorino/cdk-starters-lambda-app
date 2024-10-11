def lambda_handler(event, context):
    event_info = f"Event received: {event}"

    # Access context attributes
    context_info = (
        f"Function Name: {context.function_name}\n"
        f"Memory Limit (MB): {context.memory_limit_in_mb}\n"
        f"Time Remaining (ms): {context.get_remaining_time_in_millis()}\n"
        f"Log Stream Name: {context.log_stream_name}\n"
        f"Log Group Name: {context.log_group_name}\n"
        f"AWS Request ID: {context.aws_request_id}"
    )

    # Return a combined message
    return {
        "message": "✨ ✨ Success! Hello from SAM, CDK and the Python Lambda! ✨ ✨",
        "event_info": event_info,
        "context_info": context_info
    }
