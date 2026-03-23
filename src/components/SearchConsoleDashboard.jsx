import { useEffect, useMemo, useState } from 'react';

const REDIRECT_URI = 'https://app.crmterra.com/';
const GSC_SCOPE = 'https://www.googleapis.com/auth/webmasters.readonly';

export default function SearchConsoleDashboard() {
  const clientId = import.meta.env.VITE_GSC_CLIENT_ID;
  const siteUrl = import.meta.env.VITE_GSC_SITE_URL || 'https://limostar.com/';
  const [token, setToken] = useState(null);
  const [rows, setRows] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const authUrl = useMemo(() => {
    const params = new URLSearchParams({
      client_id: clientId || '',
      redirect_uri: REDIRECT_URI,
      response_type: 'token',
      scope: GSC_SCOPE,
      include_granted_scopes: 'true',
      prompt: 'consent'
    });
    return `https://accounts.google.com/o/oauth2/v2/auth?${params.toString()}`;
  }, [clientId]);

  useEffect(() => {
    const hash = new URLSearchParams(window.location.hash.replace(/^#/, ''));
    const accessToken = hash.get('access_token');
    if (accessToken) {
      localStorage.setItem('gsc_token', accessToken);
      setToken(accessToken);
      window.history.replaceState(null, '', window.location.pathname + window.location.search);
      return;
    }

    const saved = localStorage.getItem('gsc_token');
    if (saved) setToken(saved);
  }, []);

  useEffect(() => {
    if (!token) return;
    fetchGSCData(token);
  }, [token]);

  async function fetchGSCData(accessToken) {
    setLoading(true);
    setError('');
    try {
      const response = await fetch(
        `https://www.googleapis.com/webmasters/v3/sites/${encodeURIComponent(siteUrl)}/searchAnalytics/query`,
        {
          method: 'POST',
          headers: {
            Authorization: `Bearer ${accessToken}`,
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({
            startDate: new Date(Date.now() - 28 * 24 * 60 * 60 * 1000).toISOString().slice(0, 10),
            endDate: new Date().toISOString().slice(0, 10),
            dimensions: ['query'],
            rowLimit: 50
          })
        }
      );

      const payload = await response.json();
      if (!response.ok) {
        if (response.status === 401 || response.status === 403) {
          localStorage.removeItem('gsc_token');
          setToken(null);
        }
        throw new Error(payload?.error?.message || 'GSC request failed');
      }

      const mappedRows = (payload.rows || []).map((row) => ({
        keyword: row.keys?.[0] || '',
        clicks: row.clicks || 0,
        impressions: row.impressions || 0,
        ctr: ((row.ctr || 0) * 100).toFixed(2),
        position: Number((row.position || 0).toFixed(1))
      }));
      setRows(mappedRows);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  }

  function disconnect() {
    localStorage.removeItem('gsc_token');
    setToken(null);
    setRows([]);
    setError('');
  }

  if (!token) {
    return (
      <div className="gsc-connect-overlay">
        <h2>Connect Google Search Console</h2>
        <p>Authorize with Google to load Search Console data for {siteUrl}</p>
        <a href={authUrl}>Connect GSC</a>
      </div>
    );
  }

  return (
    <section>
      <div style={{ display: 'flex', gap: 8, marginBottom: 12 }}>
        <button onClick={() => fetchGSCData(token)} disabled={loading}>
          {loading ? 'Syncing...' : 'Sync now'}
        </button>
        <button onClick={disconnect}>Disconnect</button>
      </div>
      {error && <p style={{ color: '#ef4444' }}>{error}</p>}
      <table>
        <thead>
          <tr>
            <th>Keyword</th>
            <th>Clicks</th>
            <th>Impressions</th>
            <th>CTR</th>
            <th>Position</th>
          </tr>
        </thead>
        <tbody>
          {rows.map((row, idx) => (
            <tr key={`${row.keyword}-${idx}`}>
              <td>{row.keyword}</td>
              <td>{row.clicks}</td>
              <td>{row.impressions}</td>
              <td>{row.ctr}%</td>
              <td>{row.position}</td>
            </tr>
          ))}
          {!rows.length && !loading && (
            <tr>
              <td colSpan={5}>No rows returned. Click Sync now.</td>
            </tr>
          )}
        </tbody>
      </table>
    </section>
  );
}
