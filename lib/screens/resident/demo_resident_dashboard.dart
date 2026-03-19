import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../data/mock_data.dart';
import '../../data/demo_auth.dart';

class DemoResidentDashboard extends StatefulWidget {
  const DemoResidentDashboard({super.key});
  @override State<DemoResidentDashboard> createState() => _State();
}

class _State extends State<DemoResidentDashboard> {
  int _tab = 0;
  final money = NumberFormat('#,##,###');
  Map<String,bool> votedPolls = {'p2': true};
  Map<String,int> myVotes = {'p2': 2};

  final tabs = [
    (Icons.home_rounded,        'Home'),
    (Icons.receipt_long,        'Bills'),
    (Icons.account_balance,     'Finance'),
    (Icons.campaign_outlined,   'Notices'),
    (Icons.how_to_vote_outlined,'Polls'),
    (Icons.construction,        'Fund'),
  ];

  @override
  Widget build(BuildContext context) {
    final user = context.read<DemoAuthProvider>().currentUser!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(tabs[_tab].$2),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => _showProfile(context, user),
              child: CircleAvatar(
                radius: 18, backgroundColor: AppColors.primary,
                child: Text(user.name[0], style: GoogleFonts.sora(
                  color: Colors.white, fontWeight: FontWeight.w700))),
            ),
          ),
        ],
      ),
      body: [
        _HomeTab(user: user, money: money),
        _BillsTab(money: money),
        _FinanceTab(money: money),
        _NoticesTab(),
        _PollsTab(votedPolls: votedPolls, myVotes: myVotes,
          onVote: (pid, idx) => setState(() {
            votedPolls[pid] = true; myVotes[pid] = idx; })),
        _FundTab(money: money),
      ][_tab],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primary.withOpacity(0.12),
        destinations: tabs.map((t) => NavigationDestination(
          icon: Icon(t.$1, size: 22),
          label: t.$2, selectedIcon: Icon(t.$1, color: AppColors.primary)
        )).toList(),
      ),
    );
  }

  void _showProfile(BuildContext ctx, DemoUser user) {
    showModalBottomSheet(context: ctx, backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          CircleAvatar(radius: 36, backgroundColor: AppColors.primary,
            child: Text(user.name[0], style: GoogleFonts.sora(
              fontSize: 28, color: Colors.white, fontWeight: FontWeight.w700))),
          const SizedBox(height: 12),
          Text(user.name, style: GoogleFonts.sora(
            fontSize: 18, fontWeight: FontWeight.w800)),
          Text('Flat ${user.flatNumber} · Wing ${user.wing}',
            style: GoogleFonts.nunito(fontSize: 13, color: AppColors.textHint)),
          Text(MockData.societyName,
            style: GoogleFonts.nunito(fontSize: 13, color: AppColors.textSecondary)),
          const SizedBox(height: 20),
          SizedBox(width: double.infinity, child: OutlinedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ctx.read<DemoAuthProvider>().logout();
            },
            child: const Text('Switch Role / Logout'),
          )),
        ]),
      ));
  }
}

// ── HOME TAB ──────────────────────────────────────────────────
class _HomeTab extends StatelessWidget {
  final DemoUser user;
  final NumberFormat money;
  const _HomeTab({required this.user, required this.money});

  @override
  Widget build(BuildContext context) {
    final pending = MockData.bills.where((b) => b.status == 'pending').toList();
    final totalDue = pending.fold(0.0, (s, b) => s + b.total);
    return ListView(padding: const EdgeInsets.all(16), children: [
      // Greeting card
      Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF063333), Color(0xFF0D6E6E)]),
          borderRadius: BorderRadius.circular(20)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Hello, ${user.name.split(' ')[0]} 👋',
            style: GoogleFonts.sora(fontSize: 22, fontWeight: FontWeight.w800,
              color: Colors.white)),
          Text('Flat ${user.flatNumber} · ${MockData.societyName}',
            style: GoogleFonts.nunito(fontSize: 13,
              color: Colors.white.withOpacity(0.7))),
          const SizedBox(height: 16),
          if (totalDue > 0) Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              const Icon(Icons.warning_amber, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text(
                '₹${money.format(totalDue)} pending across ${pending.length} bill(s)',
                style: GoogleFonts.sora(fontSize: 13, color: Colors.white,
                  fontWeight: FontWeight.w600))),
            ]),
          ),
        ]),
      ),
      const SizedBox(height: 16),

      // Quick stats
      Row(children: [
        _statCard('Bills Due', '${pending.length}', AppColors.error),
        const SizedBox(width: 10),
        _statCard('Amount Due', '₹${money.format(MockData.bills.where((b)=>b.status=='pending').fold(0.0,(s,b)=>s+b.total))}', AppColors.warning),
        const SizedBox(width: 10),
        _statCard('Paid This Year', '₹${money.format(7500)}', AppColors.success),
      ]),
      const SizedBox(height: 16),

      // Quick actions
      Text('Quick actions', style: GoogleFonts.sora(
        fontSize: 14, fontWeight: FontWeight.w700)),
      const SizedBox(height: 10),
      GridView.count(
        crossAxisCount: 3, shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 10, mainAxisSpacing: 10,
        childAspectRatio: 0.9,
        children: [
          _QuickAction(Icons.receipt_long,    'Pay Bills',    AppColors.primary),
          _QuickAction(Icons.account_balance, 'Finances',     AppColors.info),
          _QuickAction(Icons.campaign,        'Notices',      AppColors.secondary),
          _QuickAction(Icons.how_to_vote,     'Vote',         const Color(0xFF6C3483)),
          _QuickAction(Icons.construction,    'Fund',         AppColors.warning),
          _QuickAction(Icons.error_outline,   'Complaints',   AppColors.error),
        ],
      ),
      const SizedBox(height: 16),

      // Latest notice
      Text('Latest notice', style: GoogleFonts.sora(
        fontSize: 14, fontWeight: FontWeight.w700)),
      const SizedBox(height: 8),
      _noticePreview(MockData.notices.first),
    ]);
  }

  Widget _statCard(String label, String value, Color color) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value, style: GoogleFonts.sora(
          fontSize: 15, fontWeight: FontWeight.w900, color: color)),
        const SizedBox(height: 2),
        Text(label, style: GoogleFonts.nunito(
          fontSize: 10, color: AppColors.textHint)),
      ]),
    ));

  Widget _noticePreview(MockNotice n) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppColors.surface, borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        _typeBadge(n.type),
        const Spacer(),
        Text(n.date, style: GoogleFonts.nunito(fontSize: 11, color: AppColors.textHint)),
      ]),
      const SizedBox(height: 6),
      Text(n.title, style: GoogleFonts.sora(
        fontSize: 13, fontWeight: FontWeight.w700)),
      const SizedBox(height: 4),
      Text(n.body.split('\n').first, style: GoogleFonts.nunito(
        fontSize: 12, color: AppColors.textSecondary),
        maxLines: 2, overflow: TextOverflow.ellipsis),
    ]));

  Widget _typeBadge(String type) {
    final colors = {
      'important': AppColors.error, 'alert': AppColors.warning,
      'event': AppColors.success, 'general': AppColors.info};
    final labels = {
      'important': '🔴 Important', 'alert': '⚠️ Alert',
      'event': '🎉 Event', 'general': 'ℹ️ General'};
    final color = colors[type] ?? AppColors.info;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6)),
      child: Text(labels[type] ?? type, style: GoogleFonts.sora(
        fontSize: 10, fontWeight: FontWeight.w700, color: color)));
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon; final String label; final Color color;
  const _QuickAction(this.icon, this.label, this.color);
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: AppColors.surface, borderRadius: BorderRadius.circular(14),
      border: Border.all(color: color.withOpacity(0.2))),
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(width: 44, height: 44,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1), shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 22)),
      const SizedBox(height: 6),
      Text(label, style: GoogleFonts.sora(
        fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
        textAlign: TextAlign.center),
    ]));
}

// ── BILLS TAB ─────────────────────────────────────────────────
class _BillsTab extends StatefulWidget {
  final NumberFormat money;
  const _BillsTab({required this.money});
  @override State<_BillsTab> createState() => _BillsTabState();
}

class _BillsTabState extends State<_BillsTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;
  @override
  void initState() { super.initState(); _tabs = TabController(length:2,vsync:this); }
  @override
  Widget build(BuildContext context) {
    final pending = MockData.bills.where((b) => b.status != 'paid').toList();
    final paid    = MockData.bills.where((b) => b.status == 'paid').toList();
    final totalDue = pending.fold(0.0,(s,b)=>s+b.total);
    return Column(children: [
      TabBar(controller: _tabs,
        indicatorColor: AppColors.primary, labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textHint,
        labelStyle: GoogleFonts.sora(fontSize:13, fontWeight:FontWeight.w600),
        tabs: const [Tab(text:'💳 Pending'), Tab(text:'✅ Paid')]),
      Expanded(child: TabBarView(controller: _tabs, children: [
        // Pending
        ListView(padding:const EdgeInsets.all(16), children: [
          if (totalDue > 0) Container(
            margin:const EdgeInsets.only(bottom:14), padding:const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors:[Color(0xFFE74C3C), Color(0xFFB03A2E)]),
              borderRadius:BorderRadius.circular(16)),
            child: Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
              Text('Total Outstanding', style:GoogleFonts.sora(
                fontSize:12, color:Colors.white70)),
              Text('₹${widget.money.format(totalDue)}', style:GoogleFonts.sora(
                fontSize:32, fontWeight:FontWeight.w900, color:Colors.white)),
              Text('${pending.length} bill(s) unpaid', style:GoogleFonts.nunito(
                fontSize:12, color:Colors.white.withOpacity(0.7))),
            ])),
          ...pending.map((b) => _BillCard(bill: b, money: widget.money, isPaid: false)),
        ]),
        // Paid
        ListView(padding:const EdgeInsets.all(16), children:
          paid.map((b) => _BillCard(bill:b, money:widget.money, isPaid:true)).toList()),
      ])),
    ]);
  }
}

class _BillCard extends StatelessWidget {
  final MockBill bill; final NumberFormat money; final bool isPaid;
  const _BillCard({required this.bill, required this.money, required this.isPaid});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isPaid
            ? AppColors.success.withOpacity(0.2)
            : bill.isOverdue
                ? AppColors.error.withOpacity(0.3) : AppColors.border)),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
          decoration: BoxDecoration(
            color: isPaid
                ? AppColors.success.withOpacity(0.05)
                : bill.isOverdue
                    ? AppColors.error.withOpacity(0.05) : AppColors.surfaceVariant,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16))),
          child: Row(children: [
            Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
              Text(bill.month, style:GoogleFonts.sora(
                fontSize:15, fontWeight:FontWeight.w800)),
              Text('Maintenance', style:GoogleFonts.nunito(
                fontSize:12, color:AppColors.textHint)),
            ]),
            const Spacer(),
            Column(crossAxisAlignment:CrossAxisAlignment.end, children:[
              Text('₹${money.format(bill.total)}', style:GoogleFonts.sora(
                fontSize:18, fontWeight:FontWeight.w900,
                color: isPaid ? AppColors.success : AppColors.textPrimary)),
              Container(
                padding:const EdgeInsets.symmetric(horizontal:8, vertical:2),
                decoration:BoxDecoration(
                  color: (isPaid ? AppColors.success : bill.isOverdue ? AppColors.error : AppColors.warning).withOpacity(0.12),
                  borderRadius:BorderRadius.circular(6)),
                child: Text(
                  isPaid ? '✓ PAID' : bill.isOverdue ? '⚠ OVERDUE' : 'PENDING',
                  style:GoogleFonts.sora(fontSize:10, fontWeight:FontWeight.w800,
                    color: isPaid ? AppColors.success : bill.isOverdue ? AppColors.error : AppColors.warning))),
            ]),
          ])),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          child: Column(children: [
            _row('Base Maintenance', bill.base),
            if (bill.penalty > 0) _row('Late Penalty', bill.penalty, AppColors.error),
            if (isPaid) ...[
              const Divider(height: 14),
              if (bill.paidDate != null) _info(Icons.calendar_today, 'Paid: ${bill.paidDate}'),
              if (bill.receiptNo != null) _info(Icons.receipt, 'Receipt: ${bill.receiptNo}'),
              if (bill.utr != null) _info(Icons.tag, 'UTR: ${bill.utr}'),
            ],
            if (!isPaid) ...[
              const SizedBox(height: 10),
              SizedBox(width:double.infinity, child: ElevatedButton.icon(
                onPressed: () => _showDemoPayment(context),
                icon: const Icon(Icons.payment_rounded, size:16, color:Colors.white),
                label: Text('Pay ₹${money.format(bill.total)} via UPI',
                  style:GoogleFonts.sora(fontSize:13, fontWeight:FontWeight.w800, color:Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: bill.isOverdue ? AppColors.error : AppColors.primary,
                  shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(10))),
              )),
            ],
          ])),
      ]),
    );
  }

  Widget _row(String l, double v, [Color? c]) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(children:[
      Expanded(child:Text(l, style:GoogleFonts.nunito(fontSize:12, color:AppColors.textSecondary))),
      Text('₹${NumberFormat('#,##,###').format(v)}', style:GoogleFonts.sora(
        fontSize:12, fontWeight:FontWeight.w700, color:c ?? AppColors.textPrimary)),
    ]));

  Widget _info(IconData icon, String t) => Padding(
    padding:const EdgeInsets.symmetric(vertical:2),
    child:Row(children:[
      Icon(icon, size:12, color:AppColors.textHint),
      const SizedBox(width:6),
      Text(t, style:GoogleFonts.nunito(fontSize:11, color:AppColors.textHint)),
    ]));

  void _showDemoPayment(BuildContext ctx) {
    showModalBottomSheet(context:ctx, backgroundColor:Colors.transparent,
      builder:(_) => Container(
        padding:const EdgeInsets.all(24),
        decoration:const BoxDecoration(color:AppColors.surface,
          borderRadius:BorderRadius.vertical(top:Radius.circular(24))),
        child:Column(mainAxisSize:MainAxisSize.min, children:[
          const Text('📱', style:TextStyle(fontSize:48)),
          const SizedBox(height:12),
          Text('UPI Payment Flow',style:GoogleFonts.sora(fontSize:18,fontWeight:FontWeight.w800)),
          const SizedBox(height:8),
          Text('In the real app, this opens GPay / PhonePe / Paytm\n'
              'with pre-filled amount and society UPI ID.\n\n'
              'Payment is auto-confirmed via Cashfree webhook.',
            style:GoogleFonts.nunito(fontSize:13,color:AppColors.textSecondary, height:1.5),
            textAlign:TextAlign.center),
          const SizedBox(height:20),
          Container(
            padding:const EdgeInsets.all(12),
            decoration:BoxDecoration(color:AppColors.surfaceVariant,
              borderRadius:BorderRadius.circular(12)),
            child:Column(children:[
              _demoRow('Payee UPI', 'snsh304@cashfree'),
              _demoRow('Amount', '₹${money.format(bill.total)}'),
              _demoRow('Order ID', 'SOC_SNSH_A304_202503_XK9P'),
              _demoRow('Note', 'Maintenance-A304-Mar2025'),
            ])),
          const SizedBox(height:16),
          Row(children:[
            Expanded(child:ElevatedButton.icon(
              onPressed:()=>Navigator.pop(ctx),
              icon:const Icon(Icons.payment,color:Colors.white,size:16),
              label:Text('Simulate GPay',style:GoogleFonts.sora(fontSize:13,fontWeight:FontWeight.w700,color:Colors.white)),
              style:ElevatedButton.styleFrom(backgroundColor:AppColors.primary,
                shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(10))),
            )),
          ]),
        ])));
  }
  Widget _demoRow(String l, String v) => Padding(
    padding:const EdgeInsets.symmetric(vertical:3),
    child:Row(children:[
      SizedBox(width:90,child:Text(l,style:GoogleFonts.nunito(fontSize:12,color:AppColors.textHint))),
      Expanded(child:Text(v,style:GoogleFonts.sora(fontSize:12,fontWeight:FontWeight.w700))),
    ]));
}

// ── FINANCE TAB ─────────────────────────────────────────────────
class _FinanceTab extends StatelessWidget {
  final NumberFormat money;
  const _FinanceTab({required this.money});

  @override
  Widget build(BuildContext context) {
    final cur = MockData.monthlySummaries.last;
    final total = MockData.expenses.fold(0.0, (s, e) => s + e.amount);
    return ListView(padding: const EdgeInsets.all(16), children: [
      // Treasury card
      Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0A4F4F), Color(0xFF0D8F8F)]),
          borderRadius: BorderRadius.circular(18)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Icon(Icons.account_balance, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text('Society Treasury', style: GoogleFonts.sora(
              color: Colors.white70, fontSize: 13)),
            const Spacer(),
            Row(children: [
              Container(width: 7, height: 7,
                decoration: const BoxDecoration(
                  color: Color(0xFF4DFFA0), shape: BoxShape.circle)),
              const SizedBox(width: 4),
              Text('LIVE', style: GoogleFonts.sora(
                fontSize: 9, color: const Color(0xFF4DFFA0),
                fontWeight: FontWeight.w700)),
            ]),
          ]),
          const SizedBox(height: 10),
          Text('Rs.${money.format(MockData.treasuryBalance)}',
            style: GoogleFonts.sora(
              fontSize: 36, fontWeight: FontWeight.w800, color: Colors.white)),
          const SizedBox(height: 12),
          Row(children: [
            _wStat('Available',
              'Rs.${money.format(MockData.treasuryBalance - MockData.reserveFund)}',
              const Color(0xFF4DFFA0)),
            Container(width: 1, height: 32, color: Colors.white24,
              margin: const EdgeInsets.symmetric(horizontal: 12)),
            _wStat('Total In', _fmt(MockData.totalCollected), Colors.white),
            Container(width: 1, height: 32, color: Colors.white24,
              margin: const EdgeInsets.symmetric(horizontal: 12)),
            _wStat('Total Spent', _fmt(MockData.totalExpenses),
              const Color(0xFFFFCE7A)),
          ]),
        ])),
      const SizedBox(height: 14),

      // This month summary
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text('March 2025', style: GoogleFonts.sora(
              fontSize: 14, fontWeight: FontWeight.w700)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8)),
              child: Text(
                '+Rs.${money.format(cur.collected - cur.expenses)} net',
                style: GoogleFonts.sora(fontSize: 12,
                  fontWeight: FontWeight.w700, color: AppColors.success))),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            _pill(Icons.arrow_downward, 'Collected',
              'Rs.${money.format(cur.collected)}', AppColors.primary),
            const SizedBox(width: 10),
            _pill(Icons.arrow_upward, 'Spent',
              'Rs.${money.format(cur.expenses)}', AppColors.error),
          ]),
          const SizedBox(height: 12),
          Text('Collection rate', style: GoogleFonts.nunito(
            fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: cur.collectionRate, minHeight: 8,
              backgroundColor: AppColors.surfaceVariant,
              color: AppColors.success)),
          const SizedBox(height: 4),
          Text('${cur.paid}/${cur.total} flats paid (${(cur.collectionRate * 100).toInt()}%)',
            style: GoogleFonts.nunito(fontSize: 11, color: AppColors.textHint)),
        ])),
      const SizedBox(height: 14),

      // Category breakdown
      Text('Where money went', style: GoogleFonts.sora(
        fontSize: 13, fontWeight: FontWeight.w700)),
      const SizedBox(height: 10),
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border)),
        child: Column(children: [
          ...MockData.expenseCategories.map((c) {
            final pct = c.amount / total;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(children: [
                Row(children: [
                  Text(c.icon, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 10),
                  Expanded(child: Text(c.name, style: GoogleFonts.sora(
                    fontSize: 12, fontWeight: FontWeight.w600))),
                  Text('Rs.${money.format(c.amount)}', style: GoogleFonts.sora(
                    fontSize: 13, fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
                  const SizedBox(width: 8),
                  SizedBox(width: 34, child: Text(
                    '${(pct * 100).toInt()}%',
                    style: GoogleFonts.nunito(
                      fontSize: 11, color: AppColors.textHint),
                    textAlign: TextAlign.right)),
                ]),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: pct, minHeight: 5,
                    backgroundColor: AppColors.surfaceVariant,
                    color: c.color)),
              ]));
          }).toList(),
          const Divider(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Total March 2025', style: GoogleFonts.sora(
              fontSize: 13, fontWeight: FontWeight.w700)),
            Text('Rs.${money.format(total)}', style: GoogleFonts.sora(
              fontSize: 15, fontWeight: FontWeight.w900,
              color: AppColors.error)),
          ]),
        ])),
      const SizedBox(height: 14),

      // Expense list
      Text('All expenses', style: GoogleFonts.sora(
        fontSize: 13, fontWeight: FontWeight.w700)),
      const SizedBox(height: 8),
      ...MockData.expenses.map((e) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border)),
          child: Row(children: [
            Container(width: 40, height: 40,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(10)),
              child: Center(child: Text(e.icon,
                style: const TextStyle(fontSize: 20)))),
            const SizedBox(width: 10),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(e.title, style: GoogleFonts.sora(
                fontSize: 13, fontWeight: FontWeight.w600)),
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(4)),
                  child: Text(e.category, style: GoogleFonts.sora(
                    fontSize: 9, fontWeight: FontWeight.w700,
                    color: AppColors.primary))),
                const SizedBox(width: 6),
                Text(e.date, style: GoogleFonts.nunito(
                  fontSize: 10, color: AppColors.textHint)),
              ]),
            ])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('Rs.${money.format(e.amount)}', style: GoogleFonts.sora(
                fontSize: 14, fontWeight: FontWeight.w800,
                color: AppColors.error)),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(4)),
                child: Text(e.mode, style: GoogleFonts.sora(
                  fontSize: 9, fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary))),
            ]),
          ]));
      }).toList(),
    ]);
  }

  Widget _wStat(String l, String v, Color c) => Expanded(
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(l, style: GoogleFonts.nunito(color: Colors.white54, fontSize: 10)),
      Text(v, style: GoogleFonts.sora(
        color: c, fontSize: 12, fontWeight: FontWeight.w700)),
    ]));

  Widget _pill(IconData icon, String l, String v, Color c) =>
    Expanded(child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: c.withOpacity(0.07),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: c.withOpacity(0.15))),
      child: Row(children: [
        Icon(icon, size: 16, color: c),
        const SizedBox(width: 8),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l, style: GoogleFonts.nunito(
            fontSize: 10, color: AppColors.textHint)),
          Text(v, style: GoogleFonts.sora(
            fontSize: 13, fontWeight: FontWeight.w700, color: c)),
        ]),
      ])));

  String _fmt(double v) => v >= 100000
    ? 'Rs.${(v / 100000).toStringAsFixed(1)}L'
    : 'Rs.${(v / 1000).toStringAsFixed(0)}K';
}


// ── NOTICES TAB ───────────────────────────────────────────────
class _NoticesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(padding:const EdgeInsets.all(16),
      children:MockData.notices.map((n) => _NoticeCard(notice:n)).toList());
  }
}

class _NoticeCard extends StatefulWidget {
  final MockNotice notice;
  const _NoticeCard({required this.notice});
  @override State<_NoticeCard> createState() => _NoticeCardState();
}
class _NoticeCardState extends State<_NoticeCard> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    final n = widget.notice;
    final colors = {'important':AppColors.error,'alert':AppColors.warning,
      'event':AppColors.success,'general':AppColors.info};
    final labels = {'important':'🔴 Important','alert':'⚠️ Alert',
      'event':'🎉 Event','general':'ℹ️ General'};
    final c = colors[n.type] ?? AppColors.info;
    return Container(
      margin:const EdgeInsets.only(bottom:10),
      decoration:BoxDecoration(color:AppColors.surface,borderRadius:BorderRadius.circular(14),
        border:Border.all(color:c.withOpacity(0.2))),
      child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Container(padding:const EdgeInsets.fromLTRB(14,12,14,10),
          decoration:BoxDecoration(color:c.withOpacity(0.06),
            borderRadius:const BorderRadius.vertical(top:Radius.circular(14))),
          child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
            Row(children:[
              Container(padding:const EdgeInsets.symmetric(horizontal:8,vertical:3),
                decoration:BoxDecoration(color:c.withOpacity(0.12),borderRadius:BorderRadius.circular(6)),
                child:Text(labels[n.type]??n.type,style:GoogleFonts.sora(fontSize:10,fontWeight:FontWeight.w700,color:c))),
              const Spacer(),
              Text(n.date,style:GoogleFonts.nunito(fontSize:11,color:AppColors.textHint)),
            ]),
            const SizedBox(height:6),
            Text(n.title,style:GoogleFonts.sora(fontSize:14,fontWeight:FontWeight.w800)),
            const SizedBox(height:2),
            Text('By ${n.author}',style:GoogleFonts.nunito(fontSize:11,color:AppColors.textHint)),
          ])),
        Padding(padding:const EdgeInsets.fromLTRB(14,8,14,12),
          child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
            Text(_expanded ? n.body : n.body.split('\n').first,
              style:GoogleFonts.nunito(fontSize:13,color:AppColors.textSecondary,height:1.5),
              maxLines:_expanded ? null : 2, overflow:_expanded ? null : TextOverflow.ellipsis),
            const SizedBox(height:6),
            GestureDetector(onTap:()=>setState(()=>_expanded=!_expanded),
              child:Text(_expanded?'Show less':'Read more',style:GoogleFonts.sora(
                fontSize:12,fontWeight:FontWeight.w700,color:AppColors.primary))),
          ])),
      ]));
  }
}

// ── POLLS TAB ─────────────────────────────────────────────────
class _PollsTab extends StatelessWidget {
  final Map<String,bool> votedPolls;
  final Map<String,int> myVotes;
  final Function(String,int) onVote;
  const _PollsTab({required this.votedPolls, required this.myVotes, required this.onVote});
  @override
  Widget build(BuildContext context) {
    return ListView(padding:const EdgeInsets.all(16),
      children:MockData.polls.map((p) => _PollCard(poll:p,
        voted:votedPolls[p.id]==true, myVote:myVotes[p.id]??-1,
        onVote:(i)=>onVote(p.id,i))).toList());
  }
}

class _PollCard extends StatelessWidget {
  final MockPoll poll; final bool voted; final int myVote;
  final ValueChanged<int> onVote;
  const _PollCard({required this.poll, required this.voted,
    required this.myVote, required this.onVote});
  @override
  Widget build(BuildContext context) {
    final p = poll;
    final total = p.totalVotes;
    return Container(
      margin:const EdgeInsets.only(bottom:14),
      decoration:BoxDecoration(color:AppColors.surface,borderRadius:BorderRadius.circular(16),
        border:Border.all(color:AppColors.border)),
      child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Container(padding:const EdgeInsets.fromLTRB(16,14,16,12),
          decoration:BoxDecoration(
            color:p.status=='active'?AppColors.info.withOpacity(0.06):AppColors.surfaceVariant,
            borderRadius:const BorderRadius.vertical(top:Radius.circular(16))),
          child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
            Row(children:[
              Container(padding:const EdgeInsets.symmetric(horizontal:8,vertical:3),
                decoration:BoxDecoration(
                  color:(p.status=='active'?AppColors.info:AppColors.textHint).withOpacity(0.12),
                  borderRadius:BorderRadius.circular(6)),
                child:Text(p.status=='active'?'🗳 Active':'🔒 Closed',
                  style:GoogleFonts.sora(fontSize:10,fontWeight:FontWeight.w700,
                    color:p.status=='active'?AppColors.info:AppColors.textHint))),
              const Spacer(),
              Text('Deadline: ${p.deadline}',style:GoogleFonts.nunito(
                fontSize:11,color:AppColors.textHint)),
            ]),
            const SizedBox(height:6),
            Text(p.title,style:GoogleFonts.sora(fontSize:14,fontWeight:FontWeight.w800)),
            const SizedBox(height:4),
            Text(p.desc,style:GoogleFonts.nunito(fontSize:12,color:AppColors.textSecondary,height:1.4),
              maxLines:2,overflow:TextOverflow.ellipsis),
          ])),
        Padding(padding:const EdgeInsets.all(14),child:Column(children:[
          ...p.options.asMap().entries.map((entry) {
            final i = entry.key; final opt = entry.value;
            final votes = i < p.votes.length ? p.votes[i] : 0;
            final pct = total>0 ? votes/total : 0.0;
            final isMyVote = myVote == i;
            return Padding(padding:const EdgeInsets.only(bottom:8),
              child:GestureDetector(
                onTap: p.status=='active' && !voted ? ()=>onVote(i) : null,
                child:Container(padding:const EdgeInsets.all(10),
                  decoration:BoxDecoration(
                    color:isMyVote?AppColors.primary.withOpacity(0.07):AppColors.surfaceVariant,
                    borderRadius:BorderRadius.circular(10),
                    border:Border.all(color:isMyVote?AppColors.primary:AppColors.border,
                      width:isMyVote?2:1)),
                  child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                    Row(children:[
                      if(isMyVote) const Icon(Icons.check_circle,color:AppColors.primary,size:14),
                      if(isMyVote) const SizedBox(width:6),
                      Expanded(child:Text(opt,style:GoogleFonts.sora(fontSize:13,
                        fontWeight:FontWeight.w600,
                        color:isMyVote?AppColors.primary:AppColors.textPrimary))),
                      Text('$votes votes (${(pct*100).toInt()}%)',style:GoogleFonts.nunito(
                        fontSize:11,color:AppColors.textHint)),
                    ]),
                    if(voted||p.status=='closed')...[
                      const SizedBox(height:5),
                      ClipRRect(borderRadius:BorderRadius.circular(3),
                        child:LinearProgressIndicator(value:pct,minHeight:5,
                          backgroundColor:AppColors.border,
                          color:isMyVote?AppColors.primary:AppColors.textHint)),
                    ],
                  ]))));
          }),
          const SizedBox(height:4),
          Text('${total} of ${p.totalEligible} eligible voters participated',
            style:GoogleFonts.nunito(fontSize:11,color:AppColors.textHint)),
        ])),
      ]));
  }
}

// ── FUND TAB ─────────────────────────────────────────────────
class _FundTab extends StatelessWidget {
  final NumberFormat money;
  const _FundTab({required this.money});
  @override
  Widget build(BuildContext context) {
    final f = MockData.specialFund;
    return ListView(padding:const EdgeInsets.all(16),children:[
      // Header card
      Container(padding:const EdgeInsets.all(16),
        decoration:BoxDecoration(color:AppColors.surface,borderRadius:BorderRadius.circular(16),
          border:Border.all(color:AppColors.primary.withOpacity(0.2))),
        child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Row(children:[
            Expanded(child:Text(f.title,style:GoogleFonts.sora(fontSize:15,fontWeight:FontWeight.w800))),
            Container(padding:const EdgeInsets.symmetric(horizontal:8,vertical:3),
              decoration:BoxDecoration(color:AppColors.primary.withOpacity(0.1),borderRadius:BorderRadius.circular(6)),
              child:Text('💰 Collecting',style:GoogleFonts.sora(fontSize:10,fontWeight:FontWeight.w700,color:AppColors.primary))),
          ]),
          const SizedBox(height:4),
          Text(f.desc,style:GoogleFonts.nunito(fontSize:12,color:AppColors.textSecondary,height:1.4),
            maxLines:3,overflow:TextOverflow.ellipsis),
          const SizedBox(height:12),
          Row(children:[
            Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
              Text('₹${money.format(f.collected)} / ₹${money.format(f.totalBudget)}',
                style:GoogleFonts.sora(fontSize:13,fontWeight:FontWeight.w800,color:AppColors.success)),
              const SizedBox(height:5),
              ClipRRect(borderRadius:BorderRadius.circular(5),
                child:LinearProgressIndicator(value:f.collectedPct,minHeight:10,
                  backgroundColor:AppColors.border,color:AppColors.success)),
            ])),
            const SizedBox(width:12),
            Text('${(f.collectedPct*100).toInt()}%',style:GoogleFonts.sora(
              fontSize:28,fontWeight:FontWeight.w900,color:AppColors.success)),
          ]),
          const SizedBox(height:8),
          Row(children:[
            _statPill('${f.paidFlats} paid',AppColors.success),
            const SizedBox(width:6),
            _statPill('${f.pendingFlats} pending',AppColors.warning),
            const SizedBox(width:6),
            _statPill('Due: ${f.dueDate}',AppColors.textHint),
          ]),
        ])),
      const SizedBox(height:12),

      // My payment
      Container(padding:const EdgeInsets.all(14),
        decoration:BoxDecoration(color:AppColors.surface,borderRadius:BorderRadius.circular(14),
          border:Border.all(color:AppColors.primary.withOpacity(0.2))),
        child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Text('Your contribution',style:GoogleFonts.sora(fontSize:13,fontWeight:FontWeight.w700)),
          const SizedBox(height:10),
          Row(children:[
            Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
              Text('₹${money.format(f.myAmount)}',style:GoogleFonts.sora(
                fontSize:24,fontWeight:FontWeight.w900)),
              Text('Current milestone due',style:GoogleFonts.nunito(
                fontSize:11,color:AppColors.textHint)),
            ]),
            const Spacer(),
            Container(padding:const EdgeInsets.symmetric(horizontal:10,vertical:4),
              decoration:BoxDecoration(color:AppColors.warning.withOpacity(0.1),borderRadius:BorderRadius.circular(8)),
              child:Text('⏳ Pending',style:GoogleFonts.sora(fontSize:11,fontWeight:FontWeight.w700,color:AppColors.warning))),
          ]),
          const SizedBox(height:12),
          Row(children:[
            Expanded(child:ElevatedButton.icon(
              onPressed:()=>ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content:Text('Demo: UPI payment flow would open here'))),
              icon:const Icon(Icons.payment_rounded,size:16,color:Colors.white),
              label:Text('Pay Milestone ₹${money.format(f.myAmount*0.4)}',
                style:GoogleFonts.sora(fontSize:12,fontWeight:FontWeight.w800,color:Colors.white)),
              style:ElevatedButton.styleFrom(backgroundColor:AppColors.primary,
                shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(10))),
            )),
            const SizedBox(width:8),
            Expanded(child:ElevatedButton.icon(
              onPressed:()=>ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content:Text('Demo: Full payment UPI flow'))),
              icon:const Icon(Icons.payments_outlined,size:16,color:Colors.white),
              label:Text('Pay Full ₹${money.format(f.myAmount)}',
                style:GoogleFonts.sora(fontSize:12,fontWeight:FontWeight.w800,color:Colors.white)),
              style:ElevatedButton.styleFrom(backgroundColor:AppColors.secondary,
                shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(10))),
            )),
          ]),
        ])),
      const SizedBox(height:12),

      // Milestones
      Text('Payment milestones',style:GoogleFonts.sora(fontSize:13,fontWeight:FontWeight.w700)),
      const SizedBox(height:8),
      ...f.milestones.map((m) => Container(
        margin:const EdgeInsets.only(bottom:8),padding:const EdgeInsets.all(12),
        decoration:BoxDecoration(color:AppColors.surface,borderRadius:BorderRadius.circular(12),
          border:Border.all(color:m.status=='completed'
              ?AppColors.success.withOpacity(0.3):AppColors.border)),
        child:Row(children:[
          Icon(m.status=='completed'?Icons.check_circle:
            m.status=='active'?Icons.radio_button_checked:Icons.radio_button_unchecked,
            color:m.status=='completed'?AppColors.success:
              m.status=='active'?AppColors.primary:AppColors.textHint,size:18),
          const SizedBox(width:10),
          Expanded(child:Text(m.title,style:GoogleFonts.sora(fontSize:12,fontWeight:FontWeight.w700))),
          Text('${m.pct}%',style:GoogleFonts.sora(fontSize:14,fontWeight:FontWeight.w800,
            color:m.status=='completed'?AppColors.success:AppColors.primary)),
        ]))).toList(),
      const SizedBox(height:12),

      // Updates
      Text('Work updates',style:GoogleFonts.sora(fontSize:13,fontWeight:FontWeight.w700)),
      const SizedBox(height:8),
      ...f.updates.map((u) => Container(
        margin:const EdgeInsets.only(bottom:8),padding:const EdgeInsets.all(12),
        decoration:BoxDecoration(color:AppColors.surface,borderRadius:BorderRadius.circular(12),
          border:Border.all(color:AppColors.border)),
        child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Row(children:[
            Expanded(child:Text(u.title,style:GoogleFonts.sora(fontSize:13,fontWeight:FontWeight.w700))),
            Text(u.date,style:GoogleFonts.nunito(fontSize:11,color:AppColors.textHint)),
          ]),
          const SizedBox(height:4),
          Text(u.note,style:GoogleFonts.nunito(fontSize:12,color:AppColors.textSecondary,height:1.4)),
        ]))).toList(),
    ]);
  }

  Widget _statPill(String t, Color c) => Container(
    padding:const EdgeInsets.symmetric(horizontal:8,vertical:3),
    decoration:BoxDecoration(color:c.withOpacity(0.1),borderRadius:BorderRadius.circular(6)),
    child:Text(t,style:GoogleFonts.sora(fontSize:10,fontWeight:FontWeight.w700,color:c)));
}
