import 'package:polytick_app/data/blog_data.dart';

const pelosi3YearsPost = BlogPost(
  id: 7,
  title: "Nancy Pelosi's 3-Year Portfolio Analysis: All 42 Trades",
  slug: "nancy-pelosi-3-year-stock-trade-analysis",
  excerpt:
      "A full breakdown of \$45M in Pelosi stock trades from 2023 to 2026. See the concentration in AI and semiconductors that drove her market-beating returns.",
  metaDescription:
      "Deep dive into \$45M+ of disclosed trades. Analysis of NVIDIA, Broadcom, Apple, and more.",
  category: "Politician Trades",
  author: "Kirill Gorbounov",
  publishDate: "2026-05-07T09:00:00Z",
  modifiedDate: "2026-05-07T09:00:00Z",
  readTime: "12 min",
  image: "assets/images/blog/pelosi-3-years.png",
  content: r'''
<div class="mb-12">
  <p class="text-xl leading-relaxed mb-6">Nancy Pelosi is the most-watched trader in Congress — not because she holds any committee power over the companies she buys, but because her portfolio has an uncanny habit of outperforming. Her husband Paul Pelosi executes most of the trades (disclosed as "Spouse"), and every move gets filed under the STOCK Act.</p>
  <p class="text-xl leading-relaxed mb-6">We pulled three full years of her disclosed trades — from the NVIDIA calls in late 2023 through the January 2026 batch — and ran the numbers. The picture that emerges is not random. It's a concentrated, AI-and-semiconductor-heavy portfolio with very deliberate position cycling.</p>
  <p class="text-xl leading-relaxed">Here's the full breakdown.</p>
</div>

<h2 class="text-4xl font-black mb-8 text-black uppercase tracking-tighter">The Big Picture: Where Was Capital Deployed?</h2>
<p class="text-xl leading-relaxed mb-6">The STOCK Act requires disclosure in size ranges, not exact dollar amounts. We use the midpoint of each range to estimate allocation. Across all buy-side trades from May 2023 to January 2026, total estimated capital deployed was in the range of <strong>$15 million to $45+ million</strong>.</p>

<ul class="text-xl leading-relaxed mb-12 space-y-4">
  <li><strong>NVDA (NVIDIA Corporation):</strong> ~32% allocation ($1M–$5M entries)</li>
  <li><strong>AVGO (Broadcom Inc):</strong> ~23% allocation ($6M–$10M capital)</li>
  <li><strong>AB (AllianceBernstein):</strong> ~10% allocation</li>
  <li><strong>PANW (Palo Alto Networks):</strong> ~9% allocation</li>
  <li><strong>GOOGL (Alphabet Inc):</strong> ~8% allocation</li>
  <li><strong>AMZN (Amazon.com):</strong> ~7% allocation</li>
  <li><strong>MSFT (Microsoft Corp):</strong> ~4% allocation</li>
  <li><strong>AAPL (Apple Inc):</strong> ~3% allocation</li>
  <li><strong>VST (Vistra Corp):</strong> ~2% allocation</li>
  <li><strong>Other / Private (FORGE, REOF, TEM):</strong> ~2% allocation</li>
</ul>

<h2 class="text-4xl font-black mb-8 text-black uppercase tracking-tighter">The NVIDIA Obsession: A Play-by-Play</h2>
<p class="text-xl leading-relaxed mb-6">No stock tells Pelosi's story better than NVIDIA. She built, trimmed, and rebuilt the NVDA position <strong>seven times</strong> across the three-year period:</p>

<ul class="text-xl leading-relaxed mb-12 space-y-4">
  <li><strong>Nov 22, 2023 (Buy):</strong> $1M–$5M at ~$48.68 adjusted entry (~4x return).</li>
  <li><strong>Jun 26, 2024 (Buy):</strong> $1M–$5M at $126.39 adjusted (+64% gain).</li>
  <li><strong>Jul 26, 2024 (Buy):</strong> $1M–$5M dip buy at $113.01 adjusted entry.</li>
  <li><strong>Dec 20, 2024 (Buy):</strong> $500K–$1M at $12.00 (call options).</li>
  <li><strong>Dec 31, 2024 (Sell):</strong> $1M–$5M trim at $134.29 for year-end tax planning.</li>
  <li><strong>Jan 14, 2025 (Buy):</strong> Re-entry $250K–$500K at $131.72.</li>
  <li><strong>Dec 30, 2025 (Buy):</strong> $100K–$250K at $187.53.</li>
  <li><strong>Jan 16, 2026 (Buy):</strong> $250K–$500K at $80.00 (deep in-the-money call options).</li>
</ul>

<h2 class="text-4xl font-black mb-8 text-black uppercase tracking-tighter">Sector Allocation: It's an AI Portfolio</h2>
<ul class="text-xl leading-relaxed mb-12 space-y-4">
  <li><strong>Semiconductors:</strong> 55%</li>
  <li><strong>Mega-Cap Tech (GOOGL, AMZN, AAPL, MSFT):</strong> 22%</li>
  <li><strong>Software / Cybersecurity (PANW):</strong> 13%</li>
  <li><strong>Finance / Private / Energy (AB, VST, TEM):</strong> 10%</li>
</ul>

<h2 class="text-4xl font-black mb-8 text-black uppercase tracking-tighter">The Sell Side: What She Got Out Of</h2>
<div class="overflow-x-auto mb-12 rounded-[40px] border border-black/10 bg-white">
  <table class="w-full text-left border-collapse">
    <thead>
      <tr class="border-b border-black/10 bg-black/5">
        <th class="p-6 font-black uppercase text-sm text-slate-600">Stock</th>
        <th class="p-6 font-black uppercase text-sm text-slate-600">Date Traded</th>
        <th class="p-6 font-black uppercase text-sm text-slate-600">Size</th>
        <th class="p-6 font-black uppercase text-sm text-slate-600">Price at Sale</th>
        <th class="p-6 font-black uppercase text-sm text-slate-600">Verdict</th>
      </tr>
    </thead>
    <tbody class="text-slate-700">
      <tr class="border-b border-black/5"><td class="p-6 font-bold">AAPL</td><td class="p-6">Dec 24, 2025</td><td class="p-6">$5M–$25M</td><td class="p-6">$273.81</td><td class="p-6">Slightly early — left ~5% on table</td></tr>
      <tr class="border-b border-black/5"><td class="p-6 font-bold">AAPL</td><td class="p-6">Dec 31, 2024</td><td class="p-6">$5M–$25M</td><td class="p-6">$250.42</td><td class="p-6">Early — stock rose further</td></tr>
      <tr class="border-b border-black/5"><td class="p-6 font-bold">AMZN</td><td class="p-6">Dec 24, 2025</td><td class="p-6">$1M–$5M</td><td class="p-6">$232.38</td><td class="p-6">Sold too soon — missed ~18%</td></tr>
      <tr class="border-b border-black/5"><td class="p-6 font-bold">GOOGL</td><td class="p-6">Dec 30, 2025</td><td class="p-6">$1M–$5M</td><td class="p-6">$313.85</td><td class="p-6">Big miss — GOOGL surged after</td></tr>
      <tr class="border-b border-black/5"><td class="p-6 font-bold">NVDA</td><td class="p-6">Dec 24, 2025</td><td class="p-6">$1M–$5M</td><td class="p-6">$188.61</td><td class="p-6">Reasonable trim at near-highs</td></tr>
      <tr class="border-b border-black/5"><td class="p-6 font-bold">DIS</td><td class="p-6">Dec 30, 2025</td><td class="p-6">$1M–$5M</td><td class="p-6">$114.79</td><td class="p-6 font-bold text-green-600">✓ Smart exit — DIS declined</td></tr>
      <tr class="border-b border-black/5"><td class="p-6 font-bold">PYPL</td><td class="p-6">Dec 30, 2025</td><td class="p-6">$250K–$500K</td><td class="p-6">$59.10</td><td class="p-6 font-bold text-green-600">✓ Smart exit — PYPL dropped ~22%</td></tr>
      <tr class="border-b border-black/5"><td class="p-6 font-bold">MSFT</td><td class="p-6">Jul 26, 2024</td><td class="p-6">$1M–$5M</td><td class="p-6">$425.27</td><td class="p-6 font-bold text-green-600">✓ Timed well — sold near all-time highs</td></tr>
    </tbody>
  </table>
</div>

<h2 class="text-4xl font-black mb-8 text-black uppercase tracking-tighter">What 3 Years Tell Us</h2>
<p class="text-xl leading-relaxed mb-4"><strong>1. AI infrastructure is the core thesis:</strong> NVDA + AVGO = 55% of buy-side capital.</p>
<p class="text-xl leading-relaxed mb-4"><strong>2. Year-end is the active trading window:</strong> The vast majority of sells and new buys cluster in December–January for tax optimization.</p>
<p class="text-xl leading-relaxed mb-4"><strong>3. Options are used for leverage:</strong> Multiple trades at prices far below market value confirm options contracts (LEAPS).</p>
<p class="text-xl leading-relaxed mb-8"><strong>4. Position cycling is the strategy:</strong> Active position management around core convictions produces market-beating returns.</p>
''',
);
