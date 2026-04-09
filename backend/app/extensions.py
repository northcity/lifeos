"""
Flask 扩展实例（避免循环导入）
"""
import functools
from flask import jsonify, request
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


def require_member(f):
    """装饰器：需要有效会员码才能访问此接口"""
    @functools.wraps(f)
    def wrapper(*args, **kwargs):
        from .config import Config
        code = (request.headers.get('X-Member-Code') or '').strip()
        valid_codes = [c.strip() for c in (Config.MEMBER_CODES or '').split(',') if c.strip()]
        if not valid_codes:
            # 未配置任何会员码时放行（开发模式 / 未启用会员制）
            return f(*args, **kwargs)
        if code not in valid_codes:
            return jsonify({
                "success": False,
                "error": "需要有效会员码才能使用此功能，请在页面输入会员码。",
                "error_code": "MEMBER_REQUIRED"
            }), 403
        return f(*args, **kwargs)
    return wrapper
