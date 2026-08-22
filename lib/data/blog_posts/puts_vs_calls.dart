import 'package:polytick_app/data/blog_data.dart';

const putsVsCallsPost = BlogPost(
  id: 5,
  title: "Puts vs. Calls: What’s the Difference? (Beginner’s Guide)",
  slug: "puts-vs-calls-difference",
  excerpt:
      "Master the foundation of options trading. Learn the simple difference between puts and calls, how they work, and real-world examples with profit calculations.",
  metaDescription:
      "Understand puts vs calls in options trading. Plain-English guide with real examples, payoff diagrams, and clear explanations of bullish vs bearish bets.",
  category: "Education",
  author: "PolyTICK Intelligence",
  publishDate: "2026-04-12T09:00:00Z",
  modifiedDate: "2026-04-12T09:00:00Z",
  readTime: "8 min",
  image: "assets/images/blog/puts-vs-calls-widescreen-v3.png",
  faqs: [
    BlogFaq(
      question: "Which is riskier, puts or calls?",
      answer:
          "If you are buying options, both puts and calls have the exact same risk profile: the maximum amount of money you can lose is the premium you paid for the contract. You cannot lose more than your initial investment. However, selling (writing) naked calls is considered the riskiest trade in options, as your potential losses are theoretically unlimited if the stock skyrockets.",
    ),
    BlogFaq(
      question: "Can I buy both a put and a call at the same time?",
      answer:
          "Yes! This is an advanced strategy known as a \"Straddle\" or \"Strangle.\" Traders use this when they expect a stock to have a massive, explosive move (like during an earnings report), but they don't know whether the stock will go up or down. As long as the stock moves dramatically in one direction, one of the options will cover the cost of the other.",
    ),
    BlogFaq(
      question: "Do I have to actually buy or sell the 100 shares?",
      answer:
          "No. Over 90% of options contracts are closed before they expire. If your Call or Put goes up in value, you can simply sell the contract back to the market to lock in your cash profit without ever touching the actual shares of the underlying stock.",
    ),
  ],
  content: r'''
<div class="mb-12">
  <p class="text-xl leading-relaxed mb-6">If you are just stepping into the world of options trading, the jargon can feel overwhelming. Greeks, strikes, expirations, and premiums are enough to make anyone's head spin.</p>
  <p class="text-2xl font-black text-slate-900 leading-snug mb-6">But here is the secret: <strong>Every single options strategy in the world is built from just two basic building blocks—Calls and Puts.</strong></p>
  <p class="text-xl leading-relaxed">Understanding the difference between puts vs calls is the absolute foundation of options trading. Whether you want to bet that a stock will go up, bet that it will crash, or simply insure your current portfolio, you need to know which of these two contracts to use.</p>
</div>

<h2 class="text-4xl font-black mb-8 text-slate-900 uppercase tracking-tighter">Key Takeaways</h2>
<ul class="text-xl leading-relaxed mb-12 space-y-4">
  <li><strong>A Call Option</strong> gives you the right to <em>buy</em> a stock at a specific price. You buy a call when you are bullish (you think the stock will go up).</li>
  <li><strong>A Put Option</strong> gives you the right to <em>sell</em> a stock at a specific price. You buy a put when you are bearish (you think the stock will go down) or want to insure your shares.</li>
  <li>Both contracts have an expiration date. If the stock doesn't move in your favor by that date, the option expires worthless.</li>
  <li>One contract controls exactly 100 shares of the underlying stock.</li>
</ul>

<h2 class="text-4xl font-black mb-8 text-slate-900 uppercase tracking-tighter">What is a Call Option?</h2>
<p class="text-xl leading-relaxed mb-6">A <strong>Call Option</strong> is a contract that gives you the right (but not the obligation) to <strong>buy</strong> 100 shares of a stock at an agreed-upon price, on or before a specific date.</p>
<p class="text-xl leading-relaxed mb-6">Traders buy calls when they are "bullish." They believe the stock price is going to rise significantly.</p>
<p class="text-xl leading-relaxed mb-8">Think of a Call Option like putting a deposit down on a house. Let's say you find a house for $300,000, but you need a month to get your cash together. You pay the seller a $5,000 non-refundable fee to lock in that $300,000 price for 30 days. If the housing market explodes and the house is suddenly worth $400,000, you still get to buy it for $300,000!</p>

<h3 class="text-3xl font-black mb-4 text-slate-900">Real-World Example: Buying an Apple (AAPL) Call</h3>
<p class="text-xl leading-relaxed mb-4">Let's say Apple is currently trading at $150. You think their new product announcement next week will cause the stock to surge.</p>
<p class="text-xl leading-relaxed mb-8">Instead of spending $15,000 to buy 100 actual shares, you buy 1 Call Option with a Strike Price of $155, expiring in two weeks. This option costs you $200 (the premium). If Apple skyrockets to $180, your Call option gives you the right to buy those shares for only $155. You instantly make a massive profit.</p>

<h2 class="text-4xl font-black mb-8 text-slate-900 uppercase tracking-tighter">What is a Put Option?</h2>
<p class="text-xl leading-relaxed mb-6">A <strong>Put Option</strong> is a contract that gives you the right (but not the obligation) to <strong>sell</strong> 100 shares of a stock at an agreed-upon price, on or before a specific date.</p>
<p class="text-xl leading-relaxed mb-6">Traders buy puts for two reasons: they are "bearish" (they want to profit from a stock crashing), or they want to buy insurance for stocks they already own.</p>
<p class="text-xl leading-relaxed mb-8">Think of a Put Option exactly like car insurance. You pay a small monthly premium to insure your $20,000 car. If you crash the car and total it (the value drops to $0), the insurer is obligated to reimburse you for the $20,000 agreed-upon value.</p>

<h3 class="text-3xl font-black mb-4 text-slate-900">Real-World Example: Buying a Tesla (TSLA) Put</h3>
<p class="text-xl leading-relaxed mb-4">Let's say Tesla is trading at $200. You believe their upcoming earnings report is going to be terrible and the stock will plummet.</p>
<p class="text-xl leading-relaxed mb-8">You buy 1 Put Option with a Strike Price of $190, expiring in one month, and it costs you $300. If Tesla crashes to $150, your Put Option gives you the right to sell shares at $190. You can sell something for $190 that is currently only worth $150 on the open market! Your $300 option will now be worth thousands.</p>

<h2 class="text-4xl font-black mb-8 text-slate-900 uppercase tracking-tighter">Puts vs Calls: Side-by-Side Comparison</h2>
<div class="overflow-x-auto mb-12 rounded-[40px] border border-slate-200 bg-white shadow-xl">
  <table class="w-full text-left border-collapse">
    <thead>
      <tr class="border-b border-slate-200 bg-slate-50">
        <th class="p-6 font-black uppercase text-sm text-slate-500">Feature</th>
        <th class="p-6 font-black uppercase text-sm text-emerald-700">Call Option</th>
        <th class="p-6 font-black uppercase text-sm text-rose-700">Put Option</th>
      </tr>
    </thead>
    <tbody class="text-slate-700 text-base">
      <tr class="border-b border-slate-100">
        <td class="p-6 font-bold text-slate-900">The Right To...</td>
        <td class="p-6">BUY 100 shares</td>
        <td class="p-6">SELL 100 shares</td>
      </tr>
      <tr class="border-b border-slate-100">
        <td class="p-6 font-bold text-slate-900">Market Outlook</td>
        <td class="p-6">Bullish (You want it to go UP)</td>
        <td class="p-6">Bearish (You want it to go DOWN)</td>
      </tr>
      <tr class="border-b border-slate-100">
        <td class="p-6 font-bold text-slate-900">Max Loss (Buyer)</td>
        <td class="p-6">The premium paid</td>
        <td class="p-6">The premium paid</td>
      </tr>
      <tr class="border-b border-slate-100">
        <td class="p-6 font-bold text-slate-900">Max Profit</td>
        <td class="p-6">Theoretically unlimited</td>
        <td class="p-6">Substantial (Stock can only drop to $0)</td>
      </tr>
      <tr>
        <td class="p-6 font-bold text-slate-900">Real-World Equivalent</td>
        <td class="p-6">A real estate deposit</td>
        <td class="p-6">An insurance policy</td>
      </tr>
    </tbody>
  </table>
</div>
''',
);
