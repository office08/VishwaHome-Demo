// ============================================================
// VishwaHome Demo — All Mock Data
// No Firebase. Everything is hardcoded for demonstration.
// ============================================================

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ── Demo users ────────────────────────────────────────────────
class DemoUser {
  final String uid, name, phone, role, flatNumber, wing, societyId, flatId;
  const DemoUser({
    required this.uid, required this.name, required this.phone,
    required this.role, required this.flatNumber, required this.wing,
    required this.societyId, required this.flatId,
  });
}

class MockData {
  // ── Demo Accounts ─────────────────────────────────────────
  static const demoUsers = [
    DemoUser(uid:'sa1',name:'Vikram Mehta',     phone:'9900001111',
      role:'super_admin',  flatNumber:'N/A',    wing:'',  societyId:'soc1', flatId:''),
    DemoUser(uid:'ad1',name:'Priya Sharma',     phone:'9900002222',
      role:'society_admin',flatNumber:'A-001',  wing:'A', societyId:'soc1', flatId:'f001'),
    DemoUser(uid:'r1', name:'Rajesh Kumar',     phone:'9900003333',
      role:'resident',     flatNumber:'A-304',  wing:'A', societyId:'soc1', flatId:'f304'),
    DemoUser(uid:'r2', name:'Sneha Patel',      phone:'9900004444',
      role:'resident',     flatNumber:'B-102',  wing:'B', societyId:'soc1', flatId:'f102'),
    DemoUser(uid:'g1', name:'Ramu Watchman',    phone:'9900005555',
      role:'guard',        flatNumber:'Guard',  wing:'',  societyId:'soc1', flatId:''),
  ];

  static DemoUser get superAdmin => demoUsers[0];
  static DemoUser get admin      => demoUsers[1];
  static DemoUser get resident   => demoUsers[2];
  static DemoUser get guard      => demoUsers[4];

  // ── Society Info ──────────────────────────────────────────
  static const societyName    = 'Sunshine Apartments';
  static const societyAddress = 'Plot 14, Baner Road, Pune – 411045';
  static const totalFlats     = 120;
  static const occupiedFlats  = 114;

  // ── Treasury ──────────────────────────────────────────────
  static const treasuryBalance   = 482350.0;
  static const reserveFund       = 100000.0;
  static const totalCollected    = 2460000.0;
  static const totalExpenses     = 1980000.0;

  // ── Bills for A-304 ───────────────────────────────────────
  static final bills = [
    MockBill(id:'b1', month:'March 2025',     base:2500, penalty:0,    status:'pending',
      dueDate:'10 Mar 2025'),
    MockBill(id:'b2', month:'February 2025',  base:2500, penalty:250,  status:'pending',
      dueDate:'10 Feb 2025', isOverdue:true),
    MockBill(id:'b3', month:'January 2025',   base:2500, penalty:0,    status:'paid',
      dueDate:'10 Jan 2025', paidDate:'07 Jan 2025', receiptNo:'VH-0091', utr:'506123456789'),
    MockBill(id:'b4', month:'December 2024',  base:2500, penalty:0,    status:'paid',
      dueDate:'10 Dec 2024', paidDate:'05 Dec 2024', receiptNo:'VH-0074', utr:'506987654321'),
    MockBill(id:'b5', month:'November 2024',  base:2500, penalty:0,    status:'paid',
      dueDate:'10 Nov 2024', paidDate:'09 Nov 2024', receiptNo:'VH-0058', utr:'506111222333'),
  ];

  // ── Monthly Expenses ──────────────────────────────────────
  static final expenses = [
    MockExpense(id:'e1', title:'MSEB Electricity Bill',    category:'Electricity',
      icon:'⚡', amount:22000, date:'05 Mar 2025', mode:'NEFT', vendor:'MSEB'),
    MockExpense(id:'e2', title:'Security agency — March',  category:'Security',
      icon:'🛡', amount:15000, date:'01 Mar 2025', mode:'NEFT', vendor:'SafeGuard Pvt Ltd'),
    MockExpense(id:'e3', title:'Otis Lift AMC — Q1',       category:'Lift AMC',
      icon:'🛗', amount:12000, date:'02 Mar 2025', mode:'Cheque', vendor:'Otis Elevators'),
    MockExpense(id:'e4', title:'CCTV camera repair',       category:'Repairs',
      icon:'🔧', amount:4500,  date:'12 Mar 2025', mode:'Cash', vendor:'TechVision'),
    MockExpense(id:'e5', title:'Cleaning staff salaries',  category:'Cleaning',
      icon:'🧹', amount:8500,  date:'01 Mar 2025', mode:'UPI', vendor:''),
    MockExpense(id:'e6', title:'Water tanker × 3',         category:'Water',
      icon:'💧', amount:3600,  date:'08 Mar 2025', mode:'Cash', vendor:''),
    MockExpense(id:'e7', title:'Garden maintenance',       category:'Gardening',
      icon:'🌿', amount:2000,  date:'15 Mar 2025', mode:'Cash', vendor:''),
    MockExpense(id:'e8', title:'Staff salary — watchman',  category:'Salary',
      icon:'👷', amount:12000, date:'01 Mar 2025', mode:'UPI', vendor:''),
  ];

  // ── Expense categories summary ────────────────────────────
  static final expenseCategories = [
    MockCategory('Electricity', '⚡', 22000, AppColors.info),
    MockCategory('Security',    '🛡', 15000, AppColors.primary),
    MockCategory('Salary',      '👷', 12000, AppColors.secondary),
    MockCategory('Lift AMC',    '🛗', 12000, const Color(0xFF6C3483)),
    MockCategory('Cleaning',    '🧹', 8500,  AppColors.success),
    MockCategory('Repairs',     '🔧', 4500,  AppColors.error),
    MockCategory('Water',       '💧', 3600,  AppColors.info),
    MockCategory('Gardening',   '🌿', 2000,  AppColors.success),
  ];

  // ── 6-month summaries ─────────────────────────────────────
  static final monthlySummaries = [
    MockMonthSummary('Oct 24', 112500, 61000, 90, 120),
    MockMonthSummary('Nov 24', 118000, 68200, 94, 120),
    MockMonthSummary('Dec 24', 108000, 74000, 86, 120),
    MockMonthSummary('Jan 25', 115000, 59800, 92, 120),
    MockMonthSummary('Feb 25', 120000, 72400, 96, 120),
    MockMonthSummary('Mar 25', 112500, 79600, 90, 120),
  ];

  // ── Complaints ────────────────────────────────────────────
  static final complaints = [
    MockComplaint(id:'c1', title:'Lift not working — Tower A',
      desc:'Lift in Tower A has been out of service since 3 days. Residents on upper floors are struggling.',
      flat:'A-304', date:'14 Mar 2025', status:'in_progress', category:'Lift'),
    MockComplaint(id:'c2', title:'Water supply irregular — B wing',
      desc:'Morning water supply is being cut off before 7 AM for the past week.',
      flat:'B-210', date:'10 Mar 2025', status:'open', category:'Water'),
    MockComplaint(id:'c3', title:'Parking gate broken',
      desc:'The automated parking gate is stuck open. Security risk.',
      flat:'A-105', date:'05 Mar 2025', status:'resolved', category:'Parking'),
    MockComplaint(id:'c4', title:'Common area lights not working',
      desc:'Corridor lights on 3rd floor of B block are not working since 5 days.',
      flat:'B-301', date:'01 Mar 2025', status:'resolved', category:'Electrical'),
  ];

  // ── Notices ────────────────────────────────────────────────
  static final notices = [
    MockNotice(id:'n1', title:'Annual General Meeting — April 2025',
      body:'Dear Residents,\nThe Annual General Meeting of Sunshine Apartments will be held on Sunday, 6th April 2025 at 10:00 AM in the Community Hall.\n\nAgenda:\n1. Review of FY 2024-25 accounts\n2. Election of new committee members\n3. Proposed maintenance increase for FY 2025-26\n4. Special fund for entrance gate renovation\n\nYour presence is requested.',
      date:'15 Mar 2025', type:'important', author:'Admin'),
    MockNotice(id:'n2', title:'Water supply shutdown — 20 March',
      body:'Due to pipeline maintenance work by Pune Municipal Corporation, water supply will be shut off on 20th March 2025 from 9 AM to 5 PM.\n\nPlease store sufficient water in advance.\n\nApologies for the inconvenience.',
      date:'17 Mar 2025', type:'alert', author:'Admin'),
    MockNotice(id:'n3', title:'Holi celebration — 14 March',
      body:'Join us for the Holi celebration at the society garden on 14th March from 9 AM to 12 PM.\n\nOrganised by the Recreation Committee.\nRefreshments will be provided.',
      date:'10 Mar 2025', type:'event', author:'Committee'),
    MockNotice(id:'n4', title:'New security protocol from April',
      body:'From 1st April 2025, all visitors must show a valid photo ID at the gate. Residents are requested to inform their guests in advance.\n\nDelivery persons must wait at the gate — no entry without resident confirmation.',
      date:'05 Mar 2025', type:'general', author:'Admin'),
  ];

  // ── Polls / Voting ────────────────────────────────────────
  static final polls = [
    MockPoll(id:'p1',
      title:'Should we upgrade CCTV to 4K cameras?',
      desc:'Current cameras are 2MP (720p). 4K upgrade will cost approx ₹85,000 (₹708/flat). Better security coverage.',
      options:['Yes, upgrade', 'No, current is fine', 'Need more info'],
      votes:[62, 28, 10], totalEligible:114, status:'active',
      deadline:'25 Mar 2025', myVote:-1),
    MockPoll(id:'p2',
      title:'Select design for society entrance gate',
      desc:'Three designs shortlisted by the committee. Estimated cost ₹1.2L.',
      options:['Modern steel gate', 'Classic iron gate', 'Automatic sliding gate'],
      votes:[45, 22, 38], totalEligible:114, status:'active',
      deadline:'22 Mar 2025', myVote:2),
    MockPoll(id:'p3',
      title:'Add a children\'s play area in the garden?',
      desc:'Convert unused corner of garden into a kids\' play zone. Estimated ₹45,000 (₹375/flat).',
      options:['Yes, add it', 'No, use space differently'],
      votes:[88, 22], totalEligible:114, status:'closed',
      deadline:'01 Feb 2025', myVote:0, result:'Yes, add it'),
  ];

  // ── Special Fund ──────────────────────────────────────────
  static final specialFund = MockFund(
    id:'sf1', title:'Society Entrance Renovation',
    desc:'Replace the old entrance gate and install automatic boom barrier, '
        'intercom system and improved landscaping at the main entrance.',
    category:'repairs', totalBudget:144000,
    perFlat:1200, collectedPct:0.68,
    paidFlats:82, totalFlats:120, pendingFlats:32, overdueFlats:6,
    status:'active', dueDate:'30 Apr 2025',
    milestones:[
      MockMilestone('Before work starts', 30, 'completed'),
      MockMilestone('During construction', 40, 'active'),
      MockMilestone('After completion',    30, 'pending'),
    ],
    updates:[
      MockUpdate('Site survey completed',
        'Architect has completed the site survey. Final drawings approved. '
        'Material procurement begins this week.',
        '10 Mar 2025', false),
      MockUpdate('Contractor selected',
        'After reviewing 4 quotations, M/s BuildRight Constructions has been '
        'selected at ₹1,38,000. Work starts 20 March.',
        '05 Mar 2025', false),
    ],
    myPaymentStatus:'pending', myAmount:1200,
  );

  // ── Visitors (Guard view) ─────────────────────────────────
  static final visitors = [
    MockVisitor(id:'v1', name:'Anand Electrician', flat:'A-304',
      purpose:'Repair', inTime:'10:30 AM', status:'inside', phone:'9876540001'),
    MockVisitor(id:'v2', name:'Ramesh (Swiggy)',   flat:'B-210',
      purpose:'Delivery', inTime:'10:15 AM', status:'departed', phone:'9876540002'),
    MockVisitor(id:'v3', name:'Kavita Desai',      flat:'A-105',
      purpose:'Guest', inTime:'09:45 AM', status:'inside', phone:'9876540003'),
    MockVisitor(id:'v4', name:'Manoj (Amazon)',    flat:'C-401',
      purpose:'Delivery', inTime:'09:20 AM', status:'departed', phone:'9876540004'),
  ];

  // ── Committee members ─────────────────────────────────────
  static final committee = [
    MockCommitteeMember('Priya Sharma',   'Chairperson',    'A-001', '9900002222'),
    MockCommitteeMember('Arun Joshi',     'Secretary',      'B-205', '9900006666'),
    MockCommitteeMember('Meena Iyer',     'Treasurer',      'A-412', '9900007777'),
    MockCommitteeMember('Suresh Nair',    'Joint Secretary','C-103', '9900008888'),
    MockCommitteeMember('Divya Kulkarni', 'Member',         'B-310', '9900009999'),
  ];

  // ── Parking ───────────────────────────────────────────────
  static final parking = [
    MockParking('A-304', '2-Wheeler', 'P-12', 'MH-12-AB-1234'),
    MockParking('A-304', '4-Wheeler', 'P-48', 'MH-12-CD-5678'),
    MockParking('B-102', '2-Wheeler', 'P-23', 'MH-12-EF-9012'),
  ];

  // ── All flats summary (Admin view) ────────────────────────
  static final allFlats = [
    MockFlatSummary('A-101','Raj Malhotra',     'paid',   2500),
    MockFlatSummary('A-201','Seema Verma',      'paid',   2500),
    MockFlatSummary('A-304','Rajesh Kumar',     'pending',2500),
    MockFlatSummary('A-401','Anita Bose',       'paid',   2750),
    MockFlatSummary('B-102','Sneha Patel',      'pending',2500),
    MockFlatSummary('B-205','Arun Joshi',       'paid',   2500),
    MockFlatSummary('B-301','Kiran Singh',      'overdue',2750),
    MockFlatSummary('C-103','Suresh Nair',      'paid',   3000),
    MockFlatSummary('C-205','Deepak Sharma',    'paid',   3000),
    MockFlatSummary('C-401','Vikram Das',       'overdue',3000),
  ];
}

// ── Mock model classes ────────────────────────────────────────
class MockBill {
  final String id, month, status, dueDate;
  final double base, penalty;
  final bool isOverdue;
  final String? paidDate, receiptNo, utr;
  const MockBill({required this.id, required this.month, required this.base,
    required this.penalty, required this.status, required this.dueDate,
    this.isOverdue = false, this.paidDate, this.receiptNo, this.utr});
  double get total => base + penalty;
}

class MockExpense {
  final String id, title, category, icon, date, mode, vendor;
  final double amount;
  const MockExpense({required this.id, required this.title, required this.category,
    required this.icon, required this.amount, required this.date,
    required this.mode, required this.vendor});
}

class MockCategory {
  final String name, icon;
  final double amount;
  final Color color;
  const MockCategory(this.name, this.icon, this.amount, this.color);
}

class MockMonthSummary {
  final String month;
  final double collected, expenses;
  final int paid, total;
  const MockMonthSummary(this.month, this.collected, this.expenses, this.paid, this.total);
  double get collectionRate => paid / total;
}

class MockComplaint {
  final String id, title, desc, flat, date, status, category;
  const MockComplaint({required this.id, required this.title, required this.desc,
    required this.flat, required this.date, required this.status,
    required this.category});
}

class MockNotice {
  final String id, title, body, date, type, author;
  const MockNotice({required this.id, required this.title, required this.body,
    required this.date, required this.type, required this.author});
}

class MockPoll {
  final String id, title, desc, status, deadline;
  final List<String> options;
  final List<int> votes;
  final int totalEligible, myVote;
  final String? result;
  const MockPoll({required this.id, required this.title, required this.desc,
    required this.options, required this.votes, required this.totalEligible,
    required this.status, required this.deadline, required this.myVote,
    this.result});
  int get totalVotes => votes.fold(0, (s, v) => s + v);
}

class MockFund {
  final String id, title, desc, category, status, dueDate;
  final double totalBudget, perFlat, collectedPct;
  final int paidFlats, totalFlats, pendingFlats, overdueFlats;
  final List<MockMilestone> milestones;
  final List<MockUpdate> updates;
  final String myPaymentStatus;
  final double myAmount;
  const MockFund({required this.id, required this.title, required this.desc,
    required this.category, required this.totalBudget, required this.perFlat,
    required this.collectedPct, required this.paidFlats, required this.totalFlats,
    required this.pendingFlats, required this.overdueFlats,
    required this.status, required this.dueDate,
    required this.milestones, required this.updates,
    required this.myPaymentStatus, required this.myAmount});
  double get collected => totalBudget * collectedPct;
}

class MockMilestone {
  final String title, status;
  final int pct;
  const MockMilestone(this.title, this.pct, this.status);
}

class MockUpdate {
  final String title, note, date;
  final bool isDelay;
  const MockUpdate(this.title, this.note, this.date, this.isDelay);
}

class MockVisitor {
  final String id, name, flat, purpose, inTime, status, phone;
  const MockVisitor({required this.id, required this.name, required this.flat,
    required this.purpose, required this.inTime, required this.status,
    required this.phone});
}

class MockCommitteeMember {
  final String name, role, flat, phone;
  const MockCommitteeMember(this.name, this.role, this.flat, this.phone);
}

class MockParking {
  final String flat, type, slot, vehicle;
  const MockParking(this.flat, this.type, this.slot, this.vehicle);
}

class MockFlatSummary {
  final String flat, owner, status;
  final double amount;
  const MockFlatSummary(this.flat, this.owner, this.status, this.amount);
}
