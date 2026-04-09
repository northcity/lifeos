"""
Flask 扩展实例（避免循环导入）
"""
from flask import jsonify
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address

limiter = Limiter(
    key_func=get_remote_address,
    storage_uri="memory://",   # 单实例内存存储，Railway 单容器足够用
    default_limits=[],          # 不设全局默认，只在需要的路由上加
)


def rate_limit_exceeded_handler(e):
    """统一的限速 429 JSON 响应"""
    return jsonify({
        "success": False,
        "error": "请求过于频繁，免费版每小时最多可发起 5 次模拟。如需更多次数请升级 VIP。",
        "error_code": "RATE_LIMIT_EXCEEDED",
        "retry_after": str(e.description)
    }), 429
