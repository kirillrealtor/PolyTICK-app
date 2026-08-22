import 'package:polytick_app/data/blog_data.dart';

const whatIsOptionsPremiumPost = BlogPost(
  id: 4,
  title: "What is Options Premium? (Intrinsic vs. Extrinsic Value)",
  slug: "what-is-options-premium",
  excerpt:
      "Understand how options premium works, why prices change, and how intrinsic vs extrinsic value determine the true cost of every options contract.",
  metaDescription:
      "A complete guide to options premium. Learn how intrinsic and extrinsic value work, how theta decay impacts pricing, and how to calculate contract costs.",
  category: "Education",
  author: "PolyTICK Intelligence",
  publishDate: "2026-04-15T09:00:00Z",
  modifiedDate: "2026-04-15T09:00:00Z",
  readTime: "6 min",
  image: "assets/images/blog/what-is-options-premium-v4.png",
  faqs: [
    BlogFaq(
      question: "Who decides the price of the premium?",
      answer:
          "Your broker doesn't set the price. The premium is determined entirely by the open market—the buyers and sellers. It is dictated by the bid/ask spread. If a lot of people suddenly want to buy a specific Call option, the sellers will demand a higher premium.",
    ),
    BlogFaq(
      question: "Do I get the premium back when I close the trade?",
      answer:
          "No. When you buy an option, the premium is instantly removed from your account cash balance and given to the seller. The only way to get your money back (and make a profit) is to sell that contract later to someone else for a higher premium than you originally paid.",
    ),
    BlogFaq(
      question: "What happens to the premium if the option expires worthless?",
      answer:
          "If you are the buyer, you lose 100% of the premium you paid. The contract disappears from your account. If you were the seller (the writer), you get to keep 100% of the premium you collected on day one.",
    ),
  ],
  content: r'''
<div class="mb-12">
  <p class="text-xl leading-relaxed mb-6">When you buy a stock, the price you pay is simply the current market value of that company's shares. But when you trade options, you aren't buying the stock itself—you are buying a contract.</p>
  <p class="text-2xl font-black text-slate-900 leading-snug mb-6">The price of that contract is called the <strong>Options Premium</strong>.</p>
  <p class="text-xl leading-relaxed">If you have ever looked at an options chain on your brokerage app and wondered why one Call option costs $50 while another costs $500, you are looking at the premium at work. Understanding exactly what makes up this price is the secret to avoiding beginner traps, like buying options that are practically guaranteed to lose money.</p>
</div>

<h2 class="text-4xl font-black mb-8 text-slate-900 uppercase tracking-tighter">Key Takeaways</h2>
<ul class="text-xl leading-relaxed mb-12 space-y-4">
  <li><strong>Options Premium</strong> is the total price a buyer pays to a seller to own an options contract.</li>
  <li>The premium is determined by the open market, but it is always made up of two parts: <strong>Intrinsic Value</strong> and <strong>Extrinsic Value</strong>.</li>
  <li><strong>Intrinsic Value</strong> is the "real" built-in value of the contract right now.</li>
  <li><strong>Extrinsic Value</strong> is the "hope" value—the extra money you pay for time and potential future movement.</li>
  <li>As an option gets closer to its expiration date, its Extrinsic Value slowly decays to zero.</li>
</ul>

<h2 class="text-4xl font-black mb-8 text-slate-900 uppercase tracking-tighter">How Options Premium is Displayed</h2>
<p class="text-xl leading-relaxed mb-4">When you look at your brokerage app, the premium is usually displayed as a per-share price.</p>
<p class="text-xl leading-relaxed mb-8">Because standard options contracts control 100 shares of stock, <strong>you must multiply the displayed premium by 100</strong> to know your actual cost.</p>
<ul class="text-xl leading-relaxed mb-12 space-y-2">
  <li>If your app says the premium is $1.50, the contract will cost you $150.</li>
  <li>If your app says the premium is $5.00, the contract will cost you $500.</li>
</ul>

<h2 class="text-4xl font-black mb-8 text-slate-900 uppercase tracking-tighter">The Two Halves of an Options Premium</h2>
<blockquote class="my-8 p-6 bg-slate-50 border-l-4 border-slate-900 text-xl font-black text-slate-900">
  Total Premium = Intrinsic Value + Extrinsic Value
</blockquote>

<h3 class="text-3xl font-black mb-4 text-slate-900">1. Intrinsic Value (The "Real" Value)</h3>
<p class="text-xl leading-relaxed mb-4">Intrinsic value is the actual, tangible money the option would be worth if you exercised it right this exact second.</p>
<p class="text-xl leading-relaxed mb-4">Let's say Apple (AAPL) is currently trading at $150 per share on the stock market. You own a Call Option that gives you the right to buy Apple at $140 (your strike price). Because your contract lets you buy the stock for $10 cheaper than the market price, your contract has an intrinsic value of $10.</p>
<p class="text-xl leading-relaxed mb-8">If an option has intrinsic value, it is considered <strong>"In-The-Money" (ITM)</strong>. If the strike price is worse than the current stock price, the intrinsic value is simply $0. It can never be negative.</p>

<h3 class="text-3xl font-black mb-4 text-slate-900">2. Extrinsic Value (The "Time & Hope" Value)</h3>
<p class="text-xl leading-relaxed mb-4">If that Apple Call option has $10 of Intrinsic Value, why is your broker charging you $12 for the total premium? That extra $2 is the <strong>Extrinsic Value</strong>. This is the price you pay for time and volatility.</p>
<p class="text-xl leading-relaxed mb-4">Extrinsic value is driven by two main factors:</p>
<ul class="text-xl leading-relaxed mb-12 space-y-2">
  <li><strong>Time to Expiration:</strong> A contract that expires in 6 months has way more potential to make a massive move than a contract expiring tomorrow. Therefore, the 6-month contract will have a much higher extrinsic value.</li>
  <li><strong>Implied Volatility (IV):</strong> If a stock is completely unpredictable and swinging wildly, the market will pump up the extrinsic value to account for this chaos.</li>
</ul>

<h2 class="text-4xl font-black mb-8 text-slate-900 uppercase tracking-tighter">The Silent Killer: Time Decay (Theta)</h2>
<p class="text-xl leading-relaxed mb-6">Here is the most important lesson for new options buyers: <strong>Extrinsic value is not permanent.</strong> Every single day that passes, the "time" portion of your premium slowly evaporates. This is known as Time Decay, or Theta.</p>
<p class="text-xl leading-relaxed mb-8">If you buy an option that is completely Out-of-the-Money (meaning it has $0 intrinsic value), 100% of the premium you paid is extrinsic value. If the stock price doesn't move, your option will slowly bleed value every single day until it expires completely worthless at $0.</p>
''',
);
