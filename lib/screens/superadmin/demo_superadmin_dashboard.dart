import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../data/mock_data.dart';
import '../../data/demo_auth.dart';

class DemoSuperAdminDashboard extends StatelessWidget {
  const DemoSuperAdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final money = NumberFormat('#,##,###');
    final societies = [
      _SocDemo('Sunshine Apartments', 'Pune', 120, 0.75, 482350),
      _SocDemo('Green Valley CHS',    'Mumbai', 84, 0.91, 312000),
      _SocDemo('Lotus Heights',       'Nashik', 60, 0.63, 198500),
      _SocDemo('Silver Oak Society',  'Pune', 200, 0.88, 725000),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
          const Text('Super Admin'),
          Text('VishwaHome Dashboard', style:GoogleFonts.nunito(
            fontSize:11, color:AppColors.textHint)),
        ]),
        actions:[
          IconButton(icon:const Icon(Icons.logout),
            onPressed:()=>context.read<DemoAuthProvider>().logout()),
        ],
      ),
      body: ListView(padding:const EdgeInsets.all(16), children:[

        // Overall KPIs
        Container(padding:const EdgeInsets.all(16),
          decoration:BoxDecoration(
            gradient:const LinearGradient(colors:[Color(0xFF26215C),Color(0xFF534AB7)]),
            borderRadius:BorderRadius.circular(18)),
          child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
            Text('Portfolio Overview',style:GoogleFonts.sora(fontSize:14,color:Colors.white70)),
            const SizedBox(height:12),
            Row(children:[
              _kpi('4', 'Societies', Colors.white),
              _kpi('464', 'Total flats', Colors.white70),
              _kpi('₹17.2L', 'Treasury', const Color(0xFF9FE1CB)),
              _kpi('79%', 'Collection', const Color(0xFFFAC775)),
            ]),
          ])),
        const SizedBox(height:16),

        // Society list
        Text('All Societies', style:GoogleFonts.sora(fontSize:14, fontWeight:FontWeight.w700)),
        const SizedBox(height:8),
        ...societies.map((s) => Container(
          margin:const EdgeInsets.only(bottom:10),
          decoration:BoxDecoration(color:AppColors.surface, borderRadius:BorderRadius.circular(16),
            border:Border.all(color:AppColors.border),
            boxShadow:[BoxShadow(color:Colors.black.withOpacity(0.03), blurRadius:8)]),
          child:Column(children:[
            Container(padding:const EdgeInsets.fromLTRB(14,12,14,10),
              decoration:BoxDecoration(color:AppColors.surfaceVariant,
                borderRadius:const BorderRadius.vertical(top:Radius.circular(16))),
              child:Row(children:[
                Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                  Text(s.name,style:GoogleFonts.sora(fontSize:14,fontWeight:FontWeight.w800)),
                  Text('${s.city} · ${s.flats} flats',style:GoogleFonts.nunito(
                    fontSize:12,color:AppColors.textHint)),
                ])),
                Column(crossAxisAlignment:CrossAxisAlignment.end,children:[
                  Text('₹${money.format(s.treasury)}',style:GoogleFonts.sora(
                    fontSize:15,fontWeight:FontWeight.w900,color:AppColors.primary)),
                  Text('treasury',style:GoogleFonts.nunito(fontSize:10,color:AppColors.textHint)),
                ]),
              ])),
            Padding(padding:const EdgeInsets.fromLTRB(14,10,14,12),child:Column(children:[
              Row(children:[
                Text('Collection rate',style:GoogleFonts.nunito(fontSize:12,color:AppColors.textSecondary)),
                const Spacer(),
                Text('${(s.collectionRate*100).toInt()}%',style:GoogleFonts.sora(
                  fontSize:13,fontWeight:FontWeight.w700,
                  color:s.collectionRate>=0.8?AppColors.success:AppColors.warning)),
              ]),
              const SizedBox(height:5),
              ClipRRect(borderRadius:BorderRadius.circular(4),
                child:LinearProgressIndicator(value:s.collectionRate,minHeight:8,
                  backgroundColor:AppColors.border,
                  color:s.collectionRate>=0.8?AppColors.success:AppColors.warning)),
              const SizedBox(height:10),
              // Feature toggles preview
              Row(children:[
                Text('Features:',style:GoogleFonts.nunito(fontSize:11,color:AppColors.textHint)),
                const SizedBox(width:6),
                ...[('Billing',true),('Fund',true),('Telegram',false),('WhatsApp',false)]
                  .map((f) => Container(
                    margin:const EdgeInsets.only(right:5),
                    padding:const EdgeInsets.symmetric(horizontal:6,vertical:2),
                    decoration:BoxDecoration(
                      color:(f.$2?AppColors.success:AppColors.textHint).withOpacity(0.1),
                      borderRadius:BorderRadius.circular(4)),
                    child:Text(f.$1,style:GoogleFonts.sora(fontSize:9,fontWeight:FontWeight.w700,
                      color:f.$2?AppColors.success:AppColors.textHint)))),
              ]),
            ])),
          ]))),
        const SizedBox(height:16),

        // Feature flags panel
        Container(padding:const EdgeInsets.all(14),
          decoration:BoxDecoration(color:AppColors.surface,borderRadius:BorderRadius.circular(14),
            border:Border.all(color:AppColors.primary.withOpacity(0.2))),
          child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
            Text('Feature Flags — Remote Config',style:GoogleFonts.sora(
              fontSize:14,fontWeight:FontWeight.w700)),
            const SizedBox(height:10),
            ...[
              ('Maintenance mode',false,'Emergency lockdown'),
              ('Billing module',true,'Monthly bill generation'),
              ('Special fund',true,'Ad-hoc collections'),
              ('Excel exports',false,'Report downloads'),
              ('Telegram alerts',false,'Notification channel'),
              ('WhatsApp',false,'Paid channel'),
            ].map((f) => Padding(
              padding:const EdgeInsets.only(bottom:8),
              child:Row(children:[
                Container(width:8,height:8,
                  decoration:BoxDecoration(color:f.$2?AppColors.success:AppColors.textHint,
                    shape:BoxShape.circle)),
                const SizedBox(width:10),
                Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                  Text(f.$1,style:GoogleFonts.sora(fontSize:12,fontWeight:FontWeight.w600)),
                  Text(f.$3,style:GoogleFonts.nunito(fontSize:10,color:AppColors.textHint)),
                ])),
                Switch(value:f.$2,activeColor:AppColors.primary,
                  onChanged:(_)=>ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:Text('Demo: Toggle ${f.$1}')))),
              ]))),
          ])),
        const SizedBox(height:16),

        // Pending settlements
        Container(padding:const EdgeInsets.all(14),
          decoration:BoxDecoration(color:AppColors.warning.withOpacity(0.07),
            borderRadius:BorderRadius.circular(14),
            border:Border.all(color:AppColors.warning.withOpacity(0.3))),
          child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
            Row(children:[
              const Icon(Icons.pending_actions,color:AppColors.warning,size:18),
              const SizedBox(width:8),
              Text('2 Settlements Pending Approval',style:GoogleFonts.sora(
                fontSize:13,fontWeight:FontWeight.w800,color:AppColors.warning)),
            ]),
            const SizedBox(height:8),
            _settlementRow('A-304 — Rajesh Kumar','Penalty waiver · ₹18,000','15 Mar'),
            const SizedBox(height:6),
            _settlementRow('B-301 — Kiran Singh','Partial settlement · ₹22,500','14 Mar'),
            const SizedBox(height:10),
            Row(children:[
              Expanded(child:OutlinedButton(
                onPressed:()=>ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content:Text('Demo: Open settlement approval screen'))),
                style:OutlinedButton.styleFrom(foregroundColor:AppColors.warning,
                  side:const BorderSide(color:AppColors.warning)),
                child:const Text('Review Settlements'))),
            ]),
          ])),
      ]),
    );
  }

  Widget _kpi(String v, String l, Color c) => Expanded(child:Column(children:[
    Text(v,style:GoogleFonts.sora(fontSize:20,fontWeight:FontWeight.w900,color:c)),
    Text(l,style:GoogleFonts.nunito(fontSize:10,color:Colors.white54),textAlign:TextAlign.center),
  ]));

  Widget _settlementRow(String title, String sub, String date) => Container(
    padding:const EdgeInsets.all(10),
    decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(8),
      border:Border.all(color:AppColors.warning.withOpacity(0.2))),
    child:Row(children:[
      Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Text(title,style:GoogleFonts.sora(fontSize:12,fontWeight:FontWeight.w700)),
        Text(sub,style:GoogleFonts.nunito(fontSize:11,color:AppColors.textHint)),
      ])),
      Text(date,style:GoogleFonts.nunito(fontSize:11,color:AppColors.textHint)),
    ]));
}

class _SocDemo {
  final String name,city; final int flats; final double collectionRate,treasury;
  const _SocDemo(this.name,this.city,this.flats,this.collectionRate,this.treasury);
}
