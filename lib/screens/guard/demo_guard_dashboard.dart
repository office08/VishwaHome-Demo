// ── GUARD DEMO DASHBOARD ──────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../data/mock_data.dart';
import '../../data/demo_auth.dart';

class DemoGuardDashboard extends StatefulWidget {
  const DemoGuardDashboard({super.key});
  @override State<DemoGuardDashboard> createState() => _GuardState();
}

class _GuardState extends State<DemoGuardDashboard> {
  List<MockVisitor> visitors = List.from(MockData.visitors);

  @override
  Widget build(BuildContext context) {
    final user = context.read<DemoAuthProvider>().currentUser!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Guard Dashboard'),
        actions: [
          IconButton(icon:const Icon(Icons.logout),
            onPressed:()=>context.read<DemoAuthProvider>().logout()),
        ],
      ),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        // Guard info
        Container(padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors:[Color(0xFF784212),Color(0xFFB07219)]),
            borderRadius: BorderRadius.circular(16)),
          child: Row(children: [
            CircleAvatar(radius:28, backgroundColor:Colors.white.withOpacity(0.2),
              child: Text(user.name[0], style: GoogleFonts.sora(
                fontSize:22, color:Colors.white, fontWeight:FontWeight.w700))),
            const SizedBox(width:14),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(user.name, style: GoogleFonts.sora(fontSize:16, fontWeight:FontWeight.w700, color:Colors.white)),
              Text(MockData.societyName, style: GoogleFonts.nunito(fontSize:12, color:Colors.white70)),
              Text('Shift: Morning (6AM–2PM)', style: GoogleFonts.nunito(fontSize:11, color:Colors.white60)),
            ]),
          ])),
        const SizedBox(height:16),

        // Quick actions
        Row(children: [
          _actionBtn(context, Icons.person_add, 'Log\nVisitor', AppColors.primary, _logVisitor),
          const SizedBox(width:10),
          _actionBtn(context, Icons.local_shipping, 'Log\nDelivery', AppColors.secondary, _logDelivery),
          const SizedBox(width:10),
          _actionBtn(context, Icons.history, 'Today\'s\nLog', AppColors.info, null),
        ]),
        const SizedBox(height:16),

        // Stats
        Row(children: [
          _stat('${visitors.where((v)=>v.status=="inside").length}', 'Inside now', AppColors.success),
          const SizedBox(width:10),
          _stat('${visitors.length}', 'Today total', AppColors.primary),
          const SizedBox(width:10),
          _stat('${visitors.where((v)=>v.purpose=="Delivery").length}', 'Deliveries', AppColors.secondary),
        ]),
        const SizedBox(height:16),

        Text('Today\'s visitor log', style:GoogleFonts.sora(fontSize:14, fontWeight:FontWeight.w700)),
        const SizedBox(height:8),
        ...visitors.map((v) => Container(
          margin: const EdgeInsets.only(bottom:8), padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color:AppColors.surface, borderRadius:BorderRadius.circular(12),
            border: Border.all(color:(v.status=='inside'?AppColors.success:AppColors.border).withOpacity(0.3))),
          child: Row(children: [
            Container(width:42, height:42,
              decoration: BoxDecoration(
                color: (v.status=='inside'?AppColors.success:AppColors.textHint).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10)),
              child: Center(child: Text(
                v.purpose=='Delivery'?'📦':'👤',
                style:const TextStyle(fontSize:20)))),
            const SizedBox(width:10),
            Expanded(child: Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
              Text(v.name, style:GoogleFonts.sora(fontSize:13, fontWeight:FontWeight.w700)),
              Text('Flat ${v.flat} · ${v.purpose} · ${v.inTime}',
                style:GoogleFonts.nunito(fontSize:11, color:AppColors.textHint)),
            ])),
            Container(padding:const EdgeInsets.symmetric(horizontal:8, vertical:3),
              decoration: BoxDecoration(
                color:(v.status=='inside'?AppColors.success:AppColors.textHint).withOpacity(0.1),
                borderRadius:BorderRadius.circular(6)),
              child: Text(v.status=='inside'?'Inside':'Departed',
                style:GoogleFonts.sora(fontSize:10, fontWeight:FontWeight.w700,
                  color:v.status=='inside'?AppColors.success:AppColors.textHint))),
          ]))),
      ]),
    );
  }

  Widget _actionBtn(BuildContext ctx, IconData icon, String label, Color c, VoidCallback? onTap) =>
    Expanded(child: GestureDetector(
      onTap: onTap ?? () => ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(content:Text('Demo: $label screen'))),
      child: Container(padding:const EdgeInsets.symmetric(vertical:16),
        decoration: BoxDecoration(color:c, borderRadius:BorderRadius.circular(14)),
        child: Column(children:[
          Icon(icon, color:Colors.white, size:26),
          const SizedBox(height:6),
          Text(label, textAlign:TextAlign.center,
            style:GoogleFonts.sora(fontSize:11, fontWeight:FontWeight.w700, color:Colors.white)),
        ]))));

  Widget _stat(String val, String label, Color c) => Expanded(child:Container(
    padding:const EdgeInsets.all(12),
    decoration: BoxDecoration(color:AppColors.surface, borderRadius:BorderRadius.circular(12),
      border:Border.all(color:c.withOpacity(0.2))),
    child: Column(children:[
      Text(val, style:GoogleFonts.sora(fontSize:24, fontWeight:FontWeight.w900, color:c)),
      Text(label, style:GoogleFonts.nunito(fontSize:10, color:AppColors.textHint), textAlign:TextAlign.center),
    ])));

  void _logVisitor() {
    final nameCtrl = TextEditingController();
    final flatCtrl = TextEditingController();
    showDialog(context:context, builder:(_) => AlertDialog(
      title: Text('Log Visitor', style:GoogleFonts.sora(fontSize:16, fontWeight:FontWeight.w800)),
      content: Column(mainAxisSize:MainAxisSize.min, children:[
        TextField(controller:nameCtrl,
          decoration:const InputDecoration(labelText:'Visitor name')),
        const SizedBox(height:8),
        TextField(controller:flatCtrl,
          decoration:const InputDecoration(labelText:'Going to flat')),
      ]),
      actions:[
        TextButton(onPressed:()=>Navigator.pop(context), child:const Text('Cancel')),
        ElevatedButton(
          onPressed:(){
            if(nameCtrl.text.isNotEmpty) {
              setState(()=>visitors.insert(0, MockVisitor(
                id:'v${visitors.length+1}', name:nameCtrl.text,
                flat:flatCtrl.text.isEmpty?'Unknown':flatCtrl.text,
                purpose:'Guest', inTime:'Now', status:'inside',
                phone:'0000000000')));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:Text('✅ ${nameCtrl.text} logged'),
                backgroundColor:AppColors.success));
            }
          },
          style:ElevatedButton.styleFrom(backgroundColor:AppColors.primary),
          child:Text('Log Entry',style:GoogleFonts.sora(fontWeight:FontWeight.w700,color:Colors.white))),
      ]));
  }

  void _logDelivery() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content:Text('Demo: Delivery log form — enter package details, notify resident')));
  }
}
