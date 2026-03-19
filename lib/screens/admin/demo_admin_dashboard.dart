import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../data/mock_data.dart';
import '../../data/demo_auth.dart';

class DemoAdminDashboard extends StatefulWidget {
  const DemoAdminDashboard({super.key});
  @override State<DemoAdminDashboard> createState() => _State();
}

class _State extends State<DemoAdminDashboard> {
  int _tab = 0;
  final money = NumberFormat('#,##,###');

  final tabs = [
    (Icons.dashboard_outlined,   'Dashboard'),
    (Icons.receipt_long_outlined,'Bills'),
    (Icons.account_balance,      'Finance'),
    (Icons.error_outline,        'Complaints'),
    (Icons.construction,         'Fund'),
  ];

  @override
  Widget build(BuildContext context) {
    final user = context.read<DemoAuthProvider>().currentUser!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(tabs[_tab].$2),
        actions: [
          Padding(padding: const EdgeInsets.only(right:12),
            child: GestureDetector(
              onTap: () => context.read<DemoAuthProvider>().logout(),
              child: CircleAvatar(radius:18, backgroundColor:AppColors.primary,
                child: Text(user.name[0], style:GoogleFonts.sora(
                  color:Colors.white, fontWeight:FontWeight.w700))))),
        ],
      ),
      body: [
        _AdminHomeTab(money: money),
        _AdminBillsTab(money: money),
        _AdminFinanceTab(money: money),
        _AdminComplaintsTab(),
        _AdminFundTab(money: money),
      ][_tab],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primary.withOpacity(0.12),
        destinations: tabs.map((t) => NavigationDestination(
          icon: Icon(t.$1, size:22), label: t.$2,
          selectedIcon: Icon(t.$1, color:AppColors.primary))).toList(),
      ),
    );
  }
}

class _AdminHomeTab extends StatelessWidget {
  final NumberFormat money;
  const _AdminHomeTab({required this.money});
  @override
  Widget build(BuildContext context) {
    final pending = MockData.allFlats.where((f) => f.status=='pending').length;
    final overdue = MockData.allFlats.where((f) => f.status=='overdue').length;
    final paid    = MockData.allFlats.where((f) => f.status=='paid').length;
    return ListView(padding:const EdgeInsets.all(16),children:[
      // KPI row
      Text('${MockData.societyName}',style:GoogleFonts.sora(fontSize:14,fontWeight:FontWeight.w700,color:AppColors.textHint)),
      const SizedBox(height:10),
      Row(children:[
        _kpi('Treasury','₹${_fmt(MockData.treasuryBalance)}',AppColors.primary,Icons.account_balance),
        const SizedBox(width:10),
        _kpi('Collected\nThis Month','₹${_fmt(112500)}',AppColors.success,Icons.arrow_downward),
      ]),
      const SizedBox(height:10),
      Row(children:[
        _kpi('Pending Flats','$pending / ${MockData.allFlats.length}',AppColors.warning,Icons.pending),
        const SizedBox(width:10),
        _kpi('Overdue Flats','$overdue flats',AppColors.error,Icons.warning_amber),
      ]),
      const SizedBox(height:16),

      // Collection progress
      Container(padding:const EdgeInsets.all(14),
        decoration:BoxDecoration(color:AppColors.surface,borderRadius:BorderRadius.circular(14),
          border:Border.all(color:AppColors.border)),
        child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Row(children:[
            Text('March 2025 Collections',style:GoogleFonts.sora(fontSize:14,fontWeight:FontWeight.w700)),
            const Spacer(),
            Text('$paid / ${MockData.allFlats.length}',style:GoogleFonts.sora(
              fontSize:13,fontWeight:FontWeight.w700,color:AppColors.primary)),
          ]),
          const SizedBox(height:8),
          ClipRRect(borderRadius:BorderRadius.circular(6),
            child:LinearProgressIndicator(value:paid/MockData.allFlats.length,minHeight:10,
              backgroundColor:AppColors.surfaceVariant,color:AppColors.success)),
          const SizedBox(height:6),
          Text('${(paid/MockData.allFlats.length*100).toInt()}% collected — $pending pending, $overdue overdue',
            style:GoogleFonts.nunito(fontSize:11,color:AppColors.textHint)),
        ])),
      const SizedBox(height:14),

      // Flat list
      Text('All flats — payment status',style:GoogleFonts.sora(fontSize:14,fontWeight:FontWeight.w700)),
      const SizedBox(height:8),
      ...MockData.allFlats.map((f) {
        Color c; String l;
        if(f.status=='paid'){c=AppColors.success;l='✅ Paid';}
        else if(f.status=='overdue'){c=AppColors.error;l='⚠️ Overdue';}
        else{c=AppColors.warning;l='⏳ Pending';}
        return Container(margin:const EdgeInsets.only(bottom:6),
          padding:const EdgeInsets.symmetric(horizontal:12,vertical:10),
          decoration:BoxDecoration(color:AppColors.surface,borderRadius:BorderRadius.circular(10),
            border:Border.all(color:c.withOpacity(0.2))),
          child:Row(children:[
            Container(padding:const EdgeInsets.symmetric(horizontal:8,vertical:4),
              decoration:BoxDecoration(color:AppColors.primary.withOpacity(0.1),borderRadius:BorderRadius.circular(6)),
              child:Text(f.flat,style:GoogleFonts.sora(fontSize:12,fontWeight:FontWeight.w800,color:AppColors.primary))),
            const SizedBox(width:10),
            Expanded(child:Text(f.owner,style:GoogleFonts.nunito(fontSize:13))),
            Text('₹${money.format(f.amount)}',style:GoogleFonts.sora(fontSize:12,fontWeight:FontWeight.w700)),
            const SizedBox(width:8),
            Container(padding:const EdgeInsets.symmetric(horizontal:7,vertical:3),
              decoration:BoxDecoration(color:c.withOpacity(0.1),borderRadius:BorderRadius.circular(6)),
              child:Text(l,style:GoogleFonts.sora(fontSize:9,fontWeight:FontWeight.w700,color:c))),
          ]));
      }),
    ]);
  }
  Widget _kpi(String l, String v, Color c, IconData icon) => Expanded(child:Container(
    padding:const EdgeInsets.all(14),
    decoration:BoxDecoration(color:AppColors.surface,borderRadius:BorderRadius.circular(14),
      border:Border.all(color:c.withOpacity(0.2))),
    child:Row(children:[
      Container(width:40,height:40,
        decoration:BoxDecoration(color:c.withOpacity(0.1),borderRadius:BorderRadius.circular(10)),
        child:Icon(icon,color:c,size:20)),
      const SizedBox(width:10),
      Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Text(l,style:GoogleFonts.nunito(fontSize:10,color:AppColors.textHint),maxLines:2),
        Text(v,style:GoogleFonts.sora(fontSize:14,fontWeight:FontWeight.w900,color:c)),
      ])),
    ])));
  String _fmt(double v) => v>=100000?'₹${(v/100000).toStringAsFixed(1)}L':'₹${(v/1000).toStringAsFixed(0)}K';
}

class _AdminBillsTab extends StatelessWidget {
  final NumberFormat money;
  const _AdminBillsTab({required this.money});
  @override
  Widget build(BuildContext context) {
    final pending = MockData.allFlats.where((f)=>f.status!='paid').toList();
    return ListView(padding:const EdgeInsets.all(16),children:[
      Container(padding:const EdgeInsets.all(14),
        decoration:BoxDecoration(color:AppColors.error.withOpacity(0.07),
          borderRadius:BorderRadius.circular(12),border:Border.all(color:AppColors.error.withOpacity(0.2))),
        child:Row(children:[
          const Icon(Icons.warning_amber,color:AppColors.error,size:18),
          const SizedBox(width:8),
          Text('${pending.length} flats have not paid March 2025',
            style:GoogleFonts.sora(fontSize:13,fontWeight:FontWeight.w700,color:AppColors.error)),
        ])),
      const SizedBox(height:14),
      Text('Pending & overdue',style:GoogleFonts.sora(fontSize:13,fontWeight:FontWeight.w700)),
      const SizedBox(height:8),
      ...pending.map((f) => Container(
        margin:const EdgeInsets.only(bottom:8),padding:const EdgeInsets.all(12),
        decoration:BoxDecoration(color:AppColors.surface,borderRadius:BorderRadius.circular(12),
          border:Border.all(color:(f.status=='overdue'?AppColors.error:AppColors.warning).withOpacity(0.25))),
        child:Row(children:[
          Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
            Text(f.flat,style:GoogleFonts.sora(fontSize:14,fontWeight:FontWeight.w800,color:AppColors.primary)),
            Text(f.owner,style:GoogleFonts.nunito(fontSize:12,color:AppColors.textSecondary)),
          ]),
          const Spacer(),
          Text('₹${money.format(f.amount)}',style:GoogleFonts.sora(fontSize:14,fontWeight:FontWeight.w800)),
          const SizedBox(width:8),
          ElevatedButton(
            onPressed:()=>ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content:Text('Demo: Mark ${f.flat} as paid'))),
            style:ElevatedButton.styleFrom(
              backgroundColor:AppColors.primary,
              padding:const EdgeInsets.symmetric(horizontal:10,vertical:6),
              shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(8))),
            child:Text('Mark Paid',style:GoogleFonts.sora(fontSize:11,fontWeight:FontWeight.w700,color:Colors.white))),
        ]))),
    ]);
  }
}

class _AdminFinanceTab extends StatelessWidget {
  final NumberFormat money;
  const _AdminFinanceTab({required this.money});
  @override
  Widget build(BuildContext context) {
    final total = MockData.expenses.fold(0.0,(s,e)=>s+e.amount);
    return ListView(padding:const EdgeInsets.all(16),children:[
      // Balance
      Container(padding:const EdgeInsets.all(16),
        decoration:BoxDecoration(gradient:const LinearGradient(
          colors:[Color(0xFF063333),Color(0xFF0D8F8F)]),
          borderRadius:BorderRadius.circular(16)),
        child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Text('Treasury Balance',style:GoogleFonts.sora(fontSize:12,color:Colors.white70)),
          Text('₹${money.format(MockData.treasuryBalance)}',style:GoogleFonts.sora(
            fontSize:32,fontWeight:FontWeight.w900,color:Colors.white)),
          const SizedBox(height:8),
          Row(children:[
            _ws('Reserve','₹${money.format(MockData.reserveFund)}',Colors.white70),
            _ws('Total In','₹${(MockData.totalCollected/100000).toStringAsFixed(1)}L',Colors.white),
            _ws('Total Spent','₹${(MockData.totalExpenses/100000).toStringAsFixed(1)}L',const Color(0xFFFFCE7A)),
          ]),
        ])),
      const SizedBox(height:12),
      Row(children:[
        Text('March expenses — ₹${money.format(total)}',style:GoogleFonts.sora(fontSize:13,fontWeight:FontWeight.w700)),
        const Spacer(),
        Container(padding:const EdgeInsets.symmetric(horizontal:10,vertical:4),
          decoration:BoxDecoration(color:AppColors.primary.withOpacity(0.1),borderRadius:BorderRadius.circular(20)),
          child:Text('+ Add Expense',style:GoogleFonts.sora(fontSize:11,fontWeight:FontWeight.w700,color:AppColors.primary))),
      ]),
      const SizedBox(height:8),
      ...MockData.expenses.map((e) => Container(
        margin:const EdgeInsets.only(bottom:7),padding:const EdgeInsets.all(12),
        decoration:BoxDecoration(color:AppColors.surface,borderRadius:BorderRadius.circular(12),
          border:Border.all(color:AppColors.border)),
        child:Row(children:[
          Container(width:38,height:38,decoration:BoxDecoration(
            color:AppColors.surfaceVariant,borderRadius:BorderRadius.circular(10)),
            child:Center(child:Text(e.icon,style:const TextStyle(fontSize:20)))),
          const SizedBox(width:10),
          Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
            Text(e.title,style:GoogleFonts.sora(fontSize:13,fontWeight:FontWeight.w600)),
            Text('${e.date} · ${e.mode}${e.vendor.isNotEmpty?' · ${e.vendor}':''}',
              style:GoogleFonts.nunito(fontSize:11,color:AppColors.textHint)),
          ])),
          Text('₹${money.format(e.amount)}',style:GoogleFonts.sora(
            fontSize:14,fontWeight:FontWeight.w800,color:AppColors.error)),
        ]))),
    ]);
  }
  Widget _ws(String l, String v, Color c) => Expanded(child:Column(
    crossAxisAlignment:CrossAxisAlignment.start,children:[
    Text(l,style:GoogleFonts.nunito(fontSize:10,color:Colors.white54)),
    Text(v,style:GoogleFonts.sora(fontSize:12,fontWeight:FontWeight.w700,color:c)),
  ]));
}

class _AdminComplaintsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(padding:const EdgeInsets.all(16),
      children:MockData.complaints.map((c) {
        Color sc; String sl;
        if(c.status=='resolved'){sc=AppColors.success;sl='✅ Resolved';}
        else if(c.status=='in_progress'){sc=AppColors.warning;sl='🔄 In Progress';}
        else{sc=AppColors.error;sl='🔴 Open';}
        return Container(margin:const EdgeInsets.only(bottom:10),
          decoration:BoxDecoration(color:AppColors.surface,borderRadius:BorderRadius.circular(14),
            border:Border.all(color:sc.withOpacity(0.2))),
          child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
            Container(padding:const EdgeInsets.fromLTRB(14,12,14,10),
              decoration:BoxDecoration(color:sc.withOpacity(0.05),
                borderRadius:const BorderRadius.vertical(top:Radius.circular(14))),
              child:Row(children:[
                Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                  Text(c.title,style:GoogleFonts.sora(fontSize:13,fontWeight:FontWeight.w800)),
                  Text('${c.flat} · ${c.date}',style:GoogleFonts.nunito(fontSize:11,color:AppColors.textHint)),
                ])),
                Container(padding:const EdgeInsets.symmetric(horizontal:8,vertical:3),
                  decoration:BoxDecoration(color:sc.withOpacity(0.12),borderRadius:BorderRadius.circular(6)),
                  child:Text(sl,style:GoogleFonts.sora(fontSize:10,fontWeight:FontWeight.w700,color:sc))),
              ])),
            Padding(padding:const EdgeInsets.fromLTRB(14,8,14,12),
              child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                Text(c.desc,style:GoogleFonts.nunito(fontSize:12,color:AppColors.textSecondary,height:1.4)),
                if(c.status!='resolved')...[
                  const SizedBox(height:10),
                  Row(children:[
                    Expanded(child:OutlinedButton(
                      onPressed:()=>ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content:Text('Demo: Mark as in progress'))),
                      child:const Text('Mark In Progress'))),
                    const SizedBox(width:8),
                    Expanded(child:ElevatedButton(
                      onPressed:()=>ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content:Text('Demo: Marked as resolved!'))),
                      style:ElevatedButton.styleFrom(backgroundColor:AppColors.success),
                      child:Text('Resolve',style:GoogleFonts.sora(color:Colors.white,fontWeight:FontWeight.w700)))),
                  ]),
                ],
              ])),
          ]));
      }).toList());
  }
}

class _AdminFundTab extends StatelessWidget {
  final NumberFormat money;
  const _AdminFundTab({required this.money});
  @override
  Widget build(BuildContext context) {
    final f = MockData.specialFund;
    final defaulters = MockData.allFlats.where((fl)=>fl.status=='overdue').toList();
    return ListView(padding:const EdgeInsets.all(16),children:[
      Container(padding:const EdgeInsets.all(16),
        decoration:BoxDecoration(color:AppColors.surface,borderRadius:BorderRadius.circular(16),
          border:Border.all(color:AppColors.primary.withOpacity(0.2))),
        child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Row(children:[
            Expanded(child:Text(f.title,style:GoogleFonts.sora(fontSize:14,fontWeight:FontWeight.w800))),
            Container(padding:const EdgeInsets.symmetric(horizontal:8,vertical:3),
              decoration:BoxDecoration(color:AppColors.primary.withOpacity(0.1),borderRadius:BorderRadius.circular(6)),
              child:Text('💰 Active',style:GoogleFonts.sora(fontSize:10,fontWeight:FontWeight.w700,color:AppColors.primary))),
          ]),
          const SizedBox(height:12),
          Row(children:[
            _stat('Total Budget','₹${money.format(f.totalBudget)}',AppColors.primary),
            _stat('Collected','₹${money.format(f.collected)}',AppColors.success),
            _stat('Remaining','₹${money.format(f.totalBudget-f.collected)}',AppColors.error),
          ]),
          const SizedBox(height:10),
          ClipRRect(borderRadius:BorderRadius.circular(5),
            child:LinearProgressIndicator(value:f.collectedPct,minHeight:10,
              backgroundColor:AppColors.border,color:AppColors.success)),
          const SizedBox(height:6),
          Row(children:[
            Text('${f.paidFlats}/${f.totalFlats} flats paid',style:GoogleFonts.nunito(fontSize:12,color:AppColors.textHint)),
            const Spacer(),
            Text('Due: ${f.dueDate}',style:GoogleFonts.nunito(fontSize:12,color:AppColors.textHint)),
          ]),
        ])),
      const SizedBox(height:12),
      Text('Defaulters (${defaulters.length})',style:GoogleFonts.sora(fontSize:13,fontWeight:FontWeight.w700,color:AppColors.error)),
      const SizedBox(height:8),
      ...defaulters.map((d) => Container(
        margin:const EdgeInsets.only(bottom:6),padding:const EdgeInsets.all(10),
        decoration:BoxDecoration(color:AppColors.surface,borderRadius:BorderRadius.circular(10),
          border:Border.all(color:AppColors.error.withOpacity(0.2))),
        child:Row(children:[
          Text(d.flat,style:GoogleFonts.sora(fontSize:13,fontWeight:FontWeight.w800,color:AppColors.error)),
          const SizedBox(width:10),
          Expanded(child:Text(d.owner,style:GoogleFonts.nunito(fontSize:12))),
          Text('₹${money.format(f.perFlat)}',style:GoogleFonts.sora(fontSize:13,fontWeight:FontWeight.w700,color:AppColors.error)),
        ]))),
    ]);
  }
  Widget _stat(String l, String v, Color c) => Expanded(child:Column(children:[
    Text(v,style:GoogleFonts.sora(fontSize:13,fontWeight:FontWeight.w900,color:c)),
    Text(l,style:GoogleFonts.nunito(fontSize:10,color:AppColors.textHint)),
  ]));
}
