import 'package:polytick_app/data/blog_data.dart';

const sellToOpenPost = BlogPost(
  id: 6,
  title: "What is Sell to Open vs. Sell to Close? (Options Guide)",
  slug: "sell-to-open-vs-sell-to-close",
  excerpt:
      "Confused by options order types? Understand the exact difference between sell to open and sell to close so you never make a costly trading mistake again.",
  metaDescription:
      "Learn the difference between sell to open vs sell to close in options trading. Step-by-step examples of writing calls vs exiting positions with real scenarios.",
  category: "Education",
  author: "PolyTICK Intelligence",
  publishDate: "2026-04-18T09:00:00Z",
  modifiedDate: "2026-04-18T09:00:00Z",
  readTime: "7 min",
  image: "assets/images/blog/sell-to-open-vs-sell-to-close-v3.png",
  faqs: [
    BlogFaq(
      question: "Is selling to close considered a day trade?",
      answer:
          "Yes, if you buy an options contract (Buy to Open) and sell it on the exact same calendar day (Sell to Close), it counts as one day trade under the Pattern Day Trader (PDT) rule. If you sell it the next day or later, it does not.",
    ),
    BlogFaq(
      question: "Can I sell to close before expiration?",
      answer:
          "Absolutely. In fact, most successful traders sell to close before expiration to lock in profits or cut losses. You do not have to wait until the expiration date to exit an options trade.",
    ),
    BlogFaq(
      question: "What happens if I forget to sell to close?",
      answer:
          "If your option is out-of-the-money at expiration, it will simply expire worthless and disappear from your account. If it is in-the-money at expiration, your broker will typically auto-exercise it, which could result in you buying or shorting 100 shares of the underlying stock. Always manage your trades before the closing bell on expiration day!",
    ),
  ],
  content: r'''
<div class="mb-12">
  <p class="text-xl leading-relaxed mb-6">If you are new to options trading, simply placing an order can feel like learning a foreign language. Unlike buying normal stocks where you just hit "Buy" or "Sell," options require you to specify exactly what kind of transaction you are making.</p>
  <p class="text-2xl font-black text-slate-900 leading-snug mb-6">Pressing the wrong button doesn't just cancel your trade—it can accidentally double your risk and cost you thousands.</p>
  <p class="text-xl leading-relaxed">The most common point of confusion for new traders is understanding the difference between <em>sell to open vs sell to close</em>. While both buttons result in you selling an options contract, they do two entirely different things to your portfolio. Let's break down exactly what each term means and when you should use them.</p>
</div>

<h2 class="text-4xl font-black mb-8 text-slate-900 uppercase tracking-tighter">Key Takeaways</h2>
<ul class="text-xl leading-relaxed mb-12 space-y-4">
  <li><strong>Sell to Open</strong> means you are <em>writing</em> a new options contract and collecting premium upfront. You are starting a brand-new short position.</li>
  <li><strong>Sell to Close</strong> means you are <em>exiting</em> an options contract you previously bought. You are ending an existing long position.</li>
  <li>Both involve selling, but they have opposite effects on your account: one adds a new obligation, the other removes one.</li>
  <li>Your broker requires this specific phrasing because it needs to know whether you're opening new risk or closing existing risk.</li>
  <li>Mastering these four brokerage order types — <em>Buy to Open</em>, <em>Buy to Close</em>, <em>Sell to Open</em>, and <em>Sell to Close</em> — is the foundation of every options trade.</li>
</ul>

<h2 class="text-4xl font-black mb-8 text-slate-900 uppercase tracking-tighter">The Basics: "Opening" vs "Closing" a Position</h2>
<p class="text-xl leading-relaxed mb-4"><strong>Opening a position</strong> means you are creating a brand new trade. You currently hold zero contracts, and you are entering the market to start a new position.</p>
<p class="text-xl leading-relaxed mb-8"><strong>Closing a position</strong> means you are exiting a trade you are already in. You are tying up loose ends to lock in a profit or take a loss.</p>

<h3 class="text-3xl font-black mb-4 text-slate-900">What is "Sell to Open" (STO)?</h3>
<p class="text-xl leading-relaxed mb-8">When you select <strong>Sell to Open</strong>, you are becoming an options writer (or seller). You are creating a brand-new short position. In this scenario, you do not currently own the options contract. Instead, you are writing it into existence and selling it to someone else. Because you are the seller, you collect a premium (cash) upfront, which is credited to your account immediately. However, you also take on an obligation.</p>

<h4 class="text-2xl font-black mb-4 text-slate-900">Real-World Example: Selling a Covered Call</h4>
<p class="text-xl leading-relaxed mb-4">Let's say you own 100 shares of Apple (AAPL), currently trading at $195 per share. You think the stock will stay flat or rise slightly over the next 30 days, and you want to generate some extra income from your shares.</p>
<ul class="text-xl leading-relaxed mb-8 space-y-2">
  <li>Open your brokerage app and navigate to the AAPL options chain.</li>
  <li>Select "Sell" as your action, and choose <strong>Sell to Open</strong>.</li>
  <li>The order fills. You collect $3.50 per share in premium — that's <strong>$350 cash</strong> deposited into your account immediately.</li>
</ul>

<h3 class="text-3xl font-black mb-4 text-slate-900">What is "Sell to Close" (STC)?</h3>
<p class="text-xl leading-relaxed mb-8">When you select <strong>Sell to Close</strong>, you are exiting an options trade that you previously bought. You would only use this button if you had previously used <strong>Buy to Open</strong>. You own an options contract, and now you want to get rid of it. By selling to close, you are selling the contract back to the market to close out your position.</p>

<h4 class="text-2xl font-black mb-4 text-slate-900">Real-World Example: Taking Profits on a Tesla Call</h4>
<ul class="text-xl leading-relaxed mb-8 space-y-2">
  <li><strong>Monday (Buy to Open):</strong> You buy 1 TSLA Call option for $4.00 ($400 total) because you think the stock will go up.</li>
  <li><strong>Thursday (Sell to Close):</strong> Tesla stock shoots up, and your Call option is now worth $11.50. To lock in your gains, you select <strong>Sell to Close</strong>.</li>
  <li>The order fills at $11.50. You receive <strong>$1,150</strong> back into your account (<strong>$750 profit</strong>).</li>
</ul>

<h2 class="text-4xl font-black mb-8 text-slate-900 uppercase tracking-tighter">Side-by-Side Comparison</h2>
<div class="overflow-x-auto mb-12 rounded-[40px] border border-slate-200 bg-white shadow-xl">
  <table class="w-full text-left border-collapse">
    <thead>
      <tr class="border-b border-slate-200 bg-slate-50">
        <th class="p-6 font-black uppercase text-sm text-slate-500">Feature</th>
        <th class="p-6 font-black uppercase text-sm text-slate-900">Sell to Open (STO)</th>
        <th class="p-6 font-black uppercase text-sm text-slate-900">Sell to Close (STC)</th>
      </tr>
    </thead>
    <tbody class="text-slate-700 text-base">
      <tr class="border-b border-slate-100">
        <td class="p-6 font-bold text-slate-900">Action</td>
        <td class="p-6">Write (create) a new options contract</td>
        <td class="p-6">Sell an options contract you already own</td>
      </tr>
      <tr class="border-b border-slate-100">
        <td class="p-6 font-bold text-slate-900">Purpose</td>
        <td class="p-6">Start a new short position & collect premium</td>
        <td class="p-6">Exit an existing long position</td>
      </tr>
      <tr class="border-b border-slate-100">
        <td class="p-6 font-bold text-slate-900">Account Impact</td>
        <td class="p-6">Adds a new obligation; you receive premium</td>
        <td class="p-6">Removes an existing position; you receive sale proceeds</td>
      </tr>
      <tr>
        <td class="p-6 font-bold text-slate-900">Prior Position</td>
        <td class="p-6">You do NOT own this contract beforehand</td>
        <td class="p-6">You DO own this contract (bought via Buy to Open)</td>
      </tr>
    </tbody>
  </table>
</div>
''',
);
