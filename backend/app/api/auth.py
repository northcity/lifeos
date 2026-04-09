"""
会员认证 API
"""
from flask import Blueprint, request, jsonify
from ..config import Config

auth_bp = Blueprint('auth', __name__)


@auth_bp.route('/verify', methods=['POST'])
def verify_code():
    """
    验证会员码
    POST /api/auth/verify  {"code": "xxx"}
    返回 {"valid": true/false}
    """
    data = request.get_json() or {}
    code = (data.get('code') or '').strip()
    valid = _is_valid_code(code)
    return jsonify({"valid": valid})


@auth_bp.route('/status', methods=['GET'])
def member_status():
    """
    查询当前请求是否持有有效会员码（根据 X-Member-Code header）
    GET /api/auth/status
    """
    code = (request.headers.get('X-Member-Code') or '').strip()
    return jsonify({"member": _is_valid_code(code)})


def _is_valid_code(code: str) -> bool:
    """检查 code 是否在配置的有效会员码列表中。若未配置任何码则放行（开发模式）。"""
    valid_codes = [c.strip() for c in (Config.MEMBER_CODES or '').split(',') if c.strip()]
    if not valid_codes:
        return True  # 未启用会员制时，所有人均为会员
    return code.strip() in valid_codes
