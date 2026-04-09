<template>
  <Teleport to="body">
    <div class="member-overlay" @click.self="$emit('close')">
      <div class="member-modal">
        <!-- Header -->
        <div class="modal-header">
          <div class="modal-icon">🔑</div>
          <h2 class="modal-title">会员专属功能</h2>
          <p class="modal-subtitle">输入会员码即可解锁完整 AI 人生模拟分析</p>
        </div>

        <!-- Input -->
        <div class="input-section">
          <label class="input-label">会员码</label>
          <div class="input-row">
            <input
              v-model="code"
              type="text"
              class="code-input"
              placeholder="输入你的会员码..."
              @keydown.enter="verify"
              :disabled="loading"
              autocomplete="off"
            />
            <button class="verify-btn" @click="verify" :disabled="loading || !code.trim()">
              <span v-if="!loading">验证</span>
              <span v-else class="loading-dot">···</span>
            </button>
          </div>
          <p v-if="errorMsg" class="error-msg">{{ errorMsg }}</p>
        </div>

        <!-- Features list -->
        <div class="features">
          <div class="feature-row">
            <span class="feature-icon member">✓</span>
            <span class="feature-text"><strong>会员</strong> — 完整 AI 人生轨迹分析，多智能体推演，深度报告</span>
          </div>
          <div class="feature-row">
            <span class="feature-icon free">○</span>
            <span class="feature-text"><strong>免费</strong> — 查看示例报告，了解 LifeOS 工作方式</span>
          </div>
        </div>

        <!-- Footer -->
        <div class="modal-footer">
          <button class="cancel-btn" @click="$emit('close')">稍后再说</button>
          <a
            href="mailto:contact@earthguide.pro?subject=LifeOS%20会员码申请"
            target="_blank"
            class="apply-btn"
          >申请会员码 ↗</a>
        </div>
      </div>
    </div>
  </Teleport>
</template>

<script setup>
import { ref } from 'vue'
import axios from 'axios'

const emit = defineEmits(['verified', 'close'])

const code = ref('')
const loading = ref(false)
const errorMsg = ref('')

const verify = async () => {
  if (!code.value.trim() || loading.value) return
  loading.value = true
  errorMsg.value = ''
  try {
    const res = await axios.post('/api/auth/verify', { code: code.value.trim() })
    if (res.data?.valid) {
      localStorage.setItem('lifeos_member_code', code.value.trim())
      emit('verified', code.value.trim())
    } else {
      errorMsg.value = '会员码无效，请检查后重试'
    }
  } catch (e) {
    errorMsg.value = '验证失败，请检查网络连接'
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.member-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.55);
  z-index: 9999;
  display: flex;
  align-items: center;
  justify-content: center;
  backdrop-filter: blur(4px);
}

.member-modal {
  background: #fff;
  width: 420px;
  max-width: calc(100vw - 40px);
  padding: 0;
  box-shadow: 0 20px 60px rgba(0,0,0,0.25);
  animation: slide-up 0.25s ease;
  overflow: hidden;
}

@keyframes slide-up {
  from { transform: translateY(20px); opacity: 0; }
  to   { transform: translateY(0);    opacity: 1; }
}

.modal-header {
  background: #000;
  color: #fff;
  padding: 30px 28px 24px;
  text-align: center;
}

.modal-icon {
  font-size: 2rem;
  margin-bottom: 10px;
}

.modal-title {
  margin: 0 0 8px;
  font-size: 1.3rem;
  font-weight: 700;
  letter-spacing: -0.5px;
}

.modal-subtitle {
  margin: 0;
  font-size: 0.85rem;
  opacity: 0.65;
  line-height: 1.5;
}

.input-section {
  padding: 24px 28px 16px;
}

.input-label {
  display: block;
  font-size: 0.8rem;
  font-weight: 600;
  letter-spacing: 0.5px;
  color: #666;
  margin-bottom: 10px;
  font-family: monospace;
  text-transform: uppercase;
}

.input-row {
  display: flex;
  gap: 8px;
}

.code-input {
  flex: 1;
  border: 1px solid #ddd;
  padding: 12px 14px;
  font-size: 0.95rem;
  font-family: monospace;
  outline: none;
  transition: border-color 0.2s;
}

.code-input:focus {
  border-color: #000;
}

.code-input:disabled {
  background: #f5f5f5;
}

.verify-btn {
  background: #FF4500;
  color: #fff;
  border: none;
  padding: 12px 20px;
  font-weight: 700;
  font-family: monospace;
  cursor: pointer;
  transition: background 0.15s;
  font-size: 0.9rem;
  min-width: 64px;
}

.verify-btn:hover:not(:disabled) { background: #e03e00; }
.verify-btn:disabled { background: #ccc; cursor: not-allowed; }

.loading-dot {
  display: inline-block;
  animation: blink 1s step-end infinite;
}

@keyframes blink { 50% { opacity: 0; } }

.error-msg {
  margin: 10px 0 0;
  color: #e03e00;
  font-size: 0.82rem;
  font-family: monospace;
}

.features {
  border-top: 1px solid #eee;
  padding: 16px 28px;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.feature-row {
  display: flex;
  align-items: flex-start;
  gap: 12px;
  font-size: 0.85rem;
  line-height: 1.5;
  color: #444;
}

.feature-icon {
  width: 18px;
  height: 18px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 0.7rem;
  font-weight: 700;
  flex-shrink: 0;
  margin-top: 1px;
}

.feature-icon.member {
  background: #000;
  color: #fff;
}

.feature-icon.free {
  border: 1.5px solid #ccc;
  color: #999;
}

.modal-footer {
  border-top: 1px solid #eee;
  padding: 16px 28px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.cancel-btn {
  background: none;
  border: none;
  color: #999;
  cursor: pointer;
  font-size: 0.85rem;
  padding: 0;
}

.cancel-btn:hover { color: #333; }

.apply-btn {
  background: #000;
  color: #fff;
  text-decoration: none;
  padding: 10px 18px;
  font-size: 0.85rem;
  font-weight: 600;
  transition: background 0.15s;
}

.apply-btn:hover { background: #333; }
</style>
