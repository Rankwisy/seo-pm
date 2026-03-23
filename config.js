// ============================================
// SEO-PM Configuration
// IMPORTANT: Add this file to .gitignore !
// Replace values below with your Supabase keys
// ============================================

const CONFIG = {
  // Supabase — find in: Project Settings > API
  SUPABASE_URL: 'https://crkhkiyzijvuedrssckw.supabase.co',
  SUPABASE_ANON_KEY: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNya2hraXl6aWp2dWVkcnNzY2t3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQxOTMzOTQsImV4cCI6MjA4OTc2OTM5NH0.7BSTt3GGSynxT0oJ8T9wzaQ_Hs3xco-2_qRB89_qHvM',

  // App password (login screen)
  APP_PASSWORD: 'rankwise2025',

  // Google PageSpeed Insights API (free)
  // Get at: https://developers.google.com/speed/docs/insights/v5/get-started
  PSI_API_KEY: 'YOUR_PSI_API_KEY',

  // Google Search Console OAuth Client ID
  // Get at: https://console.cloud.google.com/
  GSC_CLIENT_ID: (typeof window !== 'undefined' && window.GSC_CLIENT_ID) ? window.GSC_CLIENT_ID : 'YOUR_GSC_CLIENT_ID',
  GSC_REDIRECT_URI: (typeof window !== 'undefined' && window.GSC_REDIRECT_URI) ? window.GSC_REDIRECT_URI : 'https://app.crmterra.com/project.html',

  // App info
  APP_NAME: 'SEO-PM',
  OWNER: 'Abdelkrim Aridhi',
  LOCATION: 'Alicante, ES'
};
