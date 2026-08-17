// Supabase 대시보드의 Project URL과 anon key를 아래에 입력하세요.
const SUPABASE_URL = 'https://ddufmmxtzlrqqjlegtvf.supabase.co';
const SUPABASE_ANON_KEY = 'sb_publishable_hWpc5UrmIcSmoTw7Y88Y9g_Bx-jtIFz';

const isSupabaseConfigured = () => SUPABASE_URL !== 'YOUR_SUPABASE_URL' && SUPABASE_ANON_KEY !== 'YOUR_SUPABASE_ANON_KEY';
const supabaseClient = isSupabaseConfigured() ? window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY) : null;
