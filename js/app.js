const CLASS_NAME = 'SRIHS 121th 103';
const $ = (selector, parent = document) => parent.querySelector(selector);
const make = (tag, className, text) => { const el = document.createElement(tag); if (className) el.className = className; if (text !== undefined) el.textContent = text; return el; };
const formatDate = value => new Intl.DateTimeFormat('ko-KR', { year: 'numeric', month: 'long', day: 'numeric' }).format(new Date(`${String(value).slice(0, 10)}T00:00:00`));
const formatDateTime = value => new Intl.DateTimeFormat('ko-KR', { year: 'numeric', month: 'long', day: 'numeric' }).format(new Date(value));
function showToast(message, isError = false) { const toast = $('#toast'); if (!toast) return; toast.textContent = message; toast.classList.toggle('error', isError); toast.classList.add('show'); clearTimeout(window.toastTimer); window.toastTimer = setTimeout(() => toast.classList.remove('show'), 4000); }
function connectionMessage() { return '사이트 설정이 아직 완료되지 않았습니다. 관리자에게 Supabase 설정을 요청해주세요.'; }
function renderLoading(target) { target.replaceChildren(make('p', 'empty-state', '불러오는 중입니다…')); }
function renderEmpty(target, message) { target.replaceChildren(make('p', 'empty-state', message)); }
function displayError(target, message) { renderEmpty(target, message); showToast(message, true); }
function setClassName() { document.title = document.title.replace('우리 반 공지', CLASS_NAME); const name = $('#class-name'); if (name) name.textContent = CLASS_NAME; document.querySelectorAll('.brand').forEach(el => { el.textContent = CLASS_NAME; }); }
function activateNav() { const page = document.body.dataset.page; document.querySelectorAll('nav a').forEach(a => { if (a.getAttribute('href')?.includes(page === 'home' ? 'index' : page)) a.classList.add('active'); }); }
function loadMobileStyles() { if ($('#mobile-styles')) return; const link = document.createElement('link'); link.id = 'mobile-styles'; link.rel = 'stylesheet'; link.href = 'css/mobile.css'; document.head.append(link); }
document.addEventListener('DOMContentLoaded', () => { loadMobileStyles(); setClassName(); activateNav(); });
