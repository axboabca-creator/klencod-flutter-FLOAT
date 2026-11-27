import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AccFlowDzApp());
}

class AccFlowDzApp extends StatefulWidget {
  const AccFlowDzApp({super.key});

  @override
  State<AccFlowDzApp> createState() => _AccFlowDzAppState();
}

class _AccFlowDzAppState extends State<AccFlowDzApp> {
  bool _darkMode = false;

  void _setDarkMode(bool value) {
    setState(() => _darkMode = value);
  }

  @override
  Widget build(BuildContext context) {
    final lightScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF0F172A),
      primary: const Color(0xFF0F172A),
      secondary: const Color(0xFF059669),
      surface: const Color(0xFFF8FAFC),
      brightness: Brightness.light,
    );

    final darkScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF10B981),
      primary: const Color(0xFF38BDF8),
      secondary: const Color(0xFF10B981),
      surface: const Color(0xFF0F172A),
      brightness: Brightness.dark,
    );

    return MaterialApp(
      title: 'AccFlow DZ - AZEDDIN BOABCA',
      debugShowCheckedModeBanner: false,
      themeMode: _darkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightScheme,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkScheme,
        scaffoldBackgroundColor: const Color(0xFF0B1120),
        fontFamily: 'Roboto',
      ),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: MainDashboardShell(
          isDarkMode: _darkMode,
          onToggleDarkMode: _setDarkMode,
        ),
      ),
    );
  }
}

class AppSettings {
  String pinCode;
  bool lockEnabled;
  double monthlySalesGoal;
  bool pwaReady;
  String trackingBaseUrl;

  AppSettings({
    this.pinCode = '2005',
    this.lockEnabled = true,
    this.monthlySalesGoal = 250000,
    this.pwaReady = true,
    this.trackingBaseUrl = 'https://yalidine.com/track/',
  });

  Map<String, dynamic> toJson() => {
        'pinCode': pinCode,
        'lockEnabled': lockEnabled,
        'monthlySalesGoal': monthlySalesGoal,
        'pwaReady': pwaReady,
        'trackingBaseUrl': trackingBaseUrl,
      };

  factory AppSettings.fromJson(Map<String, dynamic> j) => AppSettings(
        pinCode: (j['pinCode'] ?? '2005').toString(),
        lockEnabled: j['lockEnabled'] ?? true,
        monthlySalesGoal: (j['monthlySalesGoal'] ?? 250000).toDouble(),
        pwaReady: j['pwaReady'] ?? true,
        trackingBaseUrl: (j['trackingBaseUrl'] ?? 'https://yalidine.com/track/').toString(),
      );
}

class PartnerItem {
  final String id;
  String name;
  String role;
  double sharePercent;
  double earnedCommission;

  PartnerItem({
    required this.id,
    required this.name,
    required this.role,
    required this.sharePercent,
    this.earnedCommission = 0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'role': role,
        'sharePercent': sharePercent,
        'earnedCommission': earnedCommission,
      };

  factory PartnerItem.fromJson(Map<String, dynamic> j) => PartnerItem(
        id: j['id'] ?? '',
        name: j['name'] ?? '',
        role: j['role'] ?? 'شريك',
        sharePercent: (j['sharePercent'] ?? 25).toDouble(),
        earnedCommission: (j['earnedCommission'] ?? 0).toDouble(),
      );
}

class SupplierItem {
  final String id;
  String name;
  String phone;
  String category;
  bool isForeign;
  String wilayaName;
  String addressOrCountry;
  double lastPurchasePrice;
  String lastPurchaseDate;

  SupplierItem({
    required this.id,
    required this.name,
    required this.phone,
    required this.category,
    required this.isForeign,
    required this.wilayaName,
    required this.addressOrCountry,
    this.lastPurchasePrice = 0,
    this.lastPurchaseDate = 'غير محدد',
  });

  String get locationLabel => isForeign
      ? 'خارج الوطن (${addressOrCountry.isEmpty ? 'دولي' : addressOrCountry})'
      : '$wilayaName - $addressOrCountry';

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'category': category,
        'isForeign': isForeign,
        'wilayaName': wilayaName,
        'addressOrCountry': addressOrCountry,
        'lastPurchasePrice': lastPurchasePrice,
        'lastPurchaseDate': lastPurchaseDate,
      };

  factory SupplierItem.fromJson(Map<String, dynamic> j) => SupplierItem(
        id: j['id'] ?? '',
        name: j['name'] ?? '',
        phone: j['phone'] ?? '',
        category: j['category'] ?? 'مورد إكسسوارات',
        isForeign: j['isForeign'] ?? false,
        wilayaName: j['wilayaName'] ?? 'الجزائر',
        addressOrCountry: j['addressOrCountry'] ?? '',
        lastPurchasePrice: (j['lastPurchasePrice'] ?? 0).toDouble(),
        lastPurchaseDate: j['lastPurchaseDate'] ?? 'غير محدد',
      );
}

class DebtRecord {
  final String id;
  String partyType; // 'customer' or 'supplier'
  String partyName;
  String phone;
  double totalAmount;
  double paidAmount;
  String note;
  String dateStr;

  DebtRecord({
    required this.id,
    required this.partyType,
    required this.partyName,
    required this.phone,
    required this.totalAmount,
    required this.paidAmount,
    required this.note,
    required this.dateStr,
  });

  double get remainingAmount => math.max(0.0, totalAmount - paidAmount);

  Map<String, dynamic> toJson() => {
        'id': id,
        'partyType': partyType,
        'partyName': partyName,
        'phone': phone,
        'totalAmount': totalAmount,
        'paidAmount': paidAmount,
        'note': note,
        'dateStr': dateStr,
      };

  factory DebtRecord.fromJson(Map<String, dynamic> j) => DebtRecord(
        id: j['id'] ?? '',
        partyType: j['partyType'] ?? 'customer',
        partyName: j['partyName'] ?? '',
        phone: j['phone'] ?? '',
        totalAmount: (j['totalAmount'] ?? 0).toDouble(),
        paidAmount: (j['paidAmount'] ?? 0).toDouble(),
        note: j['note'] ?? '',
        dateStr: j['dateStr'] ?? '',
      );
}
class ProductItem {
  final String id;
  String sku;
  String name;
  String category;
  double wholesalePrice;
  double sellPrice;
  int quantity;
  int minAlert;
  int soldCount;
  String cheapestSupplierName;
  double lastPurchasePrice;
  String lastPurchaseDate;
  int daysSinceLastSale;

  ProductItem({
    required this.id,
    required this.sku,
    required this.name,
    required this.category,
    required this.wholesalePrice,
    required this.sellPrice,
    required this.quantity,
    required this.minAlert,
    required this.soldCount,
    this.cheapestSupplierName = 'مورد عام',
    this.lastPurchasePrice = 0,
    this.lastPurchaseDate = '2026-10-15',
    this.daysSinceLastSale = 5,
  });

  bool get isLowStock => quantity <= minAlert;
  bool get isStagnant30Days => daysSinceLastSale >= 30;
  double get unitMargin => sellPrice - wholesalePrice;
  int get suggestedReorderQty => math.max(5, (soldCount * 0.5).ceil() + minAlert);

  Map<String, dynamic> toJson() => {
        'id': id,
        'sku': sku,
        'name': name,
        'category': category,
        'wholesalePrice': wholesalePrice,
        'sellPrice': sellPrice,
        'quantity': quantity,
        'minAlert': minAlert,
        'soldCount': soldCount,
        'cheapestSupplierName': cheapestSupplierName,
        'lastPurchasePrice': lastPurchasePrice,
        'lastPurchaseDate': lastPurchaseDate,
        'daysSinceLastSale': daysSinceLastSale,
      };

  factory ProductItem.fromJson(Map<String, dynamic> j) => ProductItem(
        id: j['id'] ?? '',
        sku: (j['sku'] ?? 'SKU-00').toString(),
        name: j['name'] ?? '',
        category: j['category'] ?? 'أخرى',
        wholesalePrice: (j['wholesalePrice'] ?? 0).toDouble(),
        sellPrice: (j['sellPrice'] ?? 0).toDouble(),
        quantity: (j['quantity'] ?? 0).toInt(),
        minAlert: (j['minAlert'] ?? 5).toInt(),
        soldCount: (j['soldCount'] ?? 0).toInt(),
        cheapestSupplierName: (j['cheapestSupplierName'] ?? 'مورد عام').toString(),
        lastPurchasePrice: (j['lastPurchasePrice'] ?? 0).toDouble(),
        lastPurchaseDate: (j['lastPurchaseDate'] ?? '2026-11-01').toString(),
        daysSinceLastSale: (j['daysSinceLastSale'] ?? 3).toInt(),
      );
}

class WilayaRate {
  final int code;
  final String name;
  double stopDesk;
  double domicile;
  double returnRate;
  double packagingCost;

  WilayaRate({
    required this.code,
    required this.name,
    required this.stopDesk,
    required this.domicile,
    required this.returnRate,
    this.packagingCost = 80,
  });

  double get estimatedReturnLoss => (stopDesk * 1.5) + packagingCost;
  bool get needsDepositAlert => returnRate >= 12;

  Map<String, dynamic> toJson() => {
        'code': code,
        'name': name,
        'stopDesk': stopDesk,
        'domicile': domicile,
        'returnRate': returnRate,
        'packagingCost': packagingCost,
      };

  factory WilayaRate.fromJson(Map<String, dynamic> j) => WilayaRate(
        code: (j['code'] ?? 0).toInt(),
        name: j['name'] ?? '',
        stopDesk: (j['stopDesk'] ?? 450).toDouble(),
        domicile: (j['domicile'] ?? 700).toDouble(),
        returnRate: (j['returnRate'] ?? 5).toDouble(),
        packagingCost: (j['packagingCost'] ?? 80).toDouble(),
      );
}

class OrderRecord {
  final String id;
  final String productName;
  final String category;
  final String customerPhone;
  final String sourceChannel;
  final String couponCode;
  final double discountAmount;
  final String trackingCode;
  String parcelStatus; // 'مؤكد', 'مسلم', 'مرتجع'
  final String wilayaName;
  final String deliveryType;
  final int qty;
  final double shippingCost;
  final double commission;
  final double netProfit;
  final double finalPrice;
  final String partnerName;
  final String dateStr;

  OrderRecord({
    required this.id,
    required this.productName,
    required this.category,
    required this.customerPhone,
    required this.sourceChannel,
    this.couponCode = '',
    this.discountAmount = 0,
    this.trackingCode = '',
    this.parcelStatus = 'مؤكد',
    required this.wilayaName,
    required this.deliveryType,
    required this.qty,
    required this.shippingCost,
    required this.commission,
    required this.netProfit,
    required this.finalPrice,
    required this.partnerName,
    required this.dateStr,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'productName': productName,
        'category': category,
        'customerPhone': customerPhone,
        'sourceChannel': sourceChannel,
        'couponCode': couponCode,
        'discountAmount': discountAmount,
        'trackingCode': trackingCode,
        'parcelStatus': parcelStatus,
        'wilayaName': wilayaName,
        'deliveryType': deliveryType,
        'qty': qty,
        'shippingCost': shippingCost,
        'commission': commission,
        'netProfit': netProfit,
        'finalPrice': finalPrice,
        'partnerName': partnerName,
        'dateStr': dateStr,
      };

  factory OrderRecord.fromJson(Map<String, dynamic> j) => OrderRecord(
        id: j['id'] ?? '',
        productName: j['productName'] ?? '',
        category: j['category'] ?? 'أخرى',
        customerPhone: j['customerPhone'] ?? '',
        sourceChannel: j['sourceChannel'] ?? 'فيسبوك',
        couponCode: j['couponCode'] ?? '',
        discountAmount: (j['discountAmount'] ?? 0).toDouble(),
        trackingCode: j['trackingCode'] ?? '',
        parcelStatus: j['parcelStatus'] ?? 'مؤكد',
        wilayaName: j['wilayaName'] ?? '',
        deliveryType: j['deliveryType'] ?? 'مكتب',
        qty: (j['qty'] ?? 1).toInt(),
        shippingCost: (j['shippingCost'] ?? 0).toDouble(),
        commission: (j['commission'] ?? 0).toDouble(),
        netProfit: (j['netProfit'] ?? 0).toDouble(),
        finalPrice: (j['finalPrice'] ?? 0).toDouble(),
        partnerName: j['partnerName'] ?? '',
        dateStr: j['dateStr'] ?? '',
      );
}

class BlacklistedCustomer {
  final String phone;
  String nameOrNote;
  String wilayaName;
  String reason;

  BlacklistedCustomer({
    required this.phone,
    required this.nameOrNote,
    required this.wilayaName,
    required this.reason,
  });

  Map<String, dynamic> toJson() => {
        'phone': phone,
        'nameOrNote': nameOrNote,
        'wilayaName': wilayaName,
        'reason': reason,
      };

  factory BlacklistedCustomer.fromJson(Map<String, dynamic> j) => BlacklistedCustomer(
        phone: j['phone'] ?? '',
        nameOrNote: j['nameOrNote'] ?? '',
        wilayaName: j['wilayaName'] ?? '',
        reason: j['reason'] ?? 'رفض الاستلام سابقاً',
      );
}

class ReviewRecord {
  final String id;
  final String subjectType; // 'زبون' or 'منتج'
  final String targetName;
  final int rating; // 1..5
  final String comment;
  final bool featuredSocialProof;

  ReviewRecord({
    required this.id,
    required this.subjectType,
    required this.targetName,
    required this.rating,
    required this.comment,
    this.featuredSocialProof = true,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'subjectType': subjectType,
        'targetName': targetName,
        'rating': rating,
        'comment': comment,
        'featuredSocialProof': featuredSocialProof,
      };

  factory ReviewRecord.fromJson(Map<String, dynamic> j) => ReviewRecord(
        id: j['id'] ?? '',
        subjectType: j['subjectType'] ?? 'منتج',
        targetName: j['targetName'] ?? '',
        rating: (j['rating'] ?? 5).toInt(),
        comment: j['comment'] ?? '',
        featuredSocialProof: j['featuredSocialProof'] ?? true,
      );
}

class CouponItem {
  final String code;
  final double discountValue;
  final String note;

  CouponItem({
    required this.code,
    required this.discountValue,
    required this.note,
  });

  Map<String, dynamic> toJson() => {
        'code': code,
        'discountValue': discountValue,
        'note': note,
      };

  factory CouponItem.fromJson(Map<String, dynamic> j) => CouponItem(
        code: j['code'] ?? '',
        discountValue: (j['discountValue'] ?? 100).toDouble(),
        note: j['note'] ?? '',
      );
}

class MarketingPage {
  final int pageNumber;
  final String thinker;
  final String title;
  final String coreIdea;
  final String trick;
  final String phoneAccessoriesCase;
  final String channelsFocus;
  final String pitfallAndFix;

  const MarketingPage({
    required this.pageNumber,
    required this.thinker,
    required this.title,
    required this.coreIdea,
    required this.trick,
    required this.phoneAccessoriesCase,
    required this.channelsFocus,
    required this.pitfallAndFix,
  });
}
const List<String> kWilayaNames = [
  'أدرار', 'الشلف', 'الأغواط', 'أم البواقي', 'باتنة', 'بجاية', 'بسكرة', 'بشار',
  'البليدة', 'البويرة', 'تمنراست', 'تبسة', 'تلمسان', 'تيارت', 'تيزي وزو', 'الجزائر',
  'الجلفة', 'جيجل', 'سطيف', 'سعيدة', 'سكيكدة', 'سيدي بلعباس', 'عنابة', 'قالمة',
  'قسنطينة', 'المدية', 'مستغانم', 'المسيلة', 'معسكر', 'ورقلة', 'وهران', 'البيض',
  'إليزي', 'برج بوعريريج', 'بومرداس', 'الطارف', 'تندوف', 'تيسمسيلت', 'الوادي',
  'خنشلة', 'سوق أهراس', 'تيبازة', 'ميلة', 'عين الدفلى', 'النعامة', 'عين تموشنت',
  'غرداية', 'غليزان', 'تيميمون', 'برج باجي مختار', 'أولاد جلال', 'بني عباس',
  'عين صالح', 'عين قزام', 'تقرت', 'جانت', 'المغير', 'المنيعة'
];

const List<String> kPartnerRoles = [
  'مؤسس شركة',
  'مدير تنفيذي للشركة',
  'نائب مدير تنفيذي',
  'مدير قسم مبيعات',
  'رئيس قسم تسويق',
  'شريك',
  'مستثمر',
  'موظف عادي في شركة',
  'موظف بالعمولة مبدئي',
];

const List<String> kDefaultSupplierCategories = [
  'مورد إكسسوارات',
  'مورد ملابس',
  'مورد شرائح وإستصلاح هواتف',
  'مورد تغليف وطباعة',
  'مورد جملة عام',
];

const List<String> kOrderSources = [
  'فيسبوك',
  'تيك توك',
  'إنستغرام',
  'واتساب',
  'ماركت بليس',
  'إحالة / زبون سابق',
];

const List<MarketingPage> kMarketingPages = [
  MarketingPage(
    pageNumber: 1,
    thinker: 'أصل التسويق ونفسية الزبون',
    title: 'النتيجة لا المواصفات',
    coreIdea: 'الزبون يشتري راحة يومية وتقليل قلق لا أرقاماً تقنية جامدة.',
    trick: 'ابدأ بالنتيجة المباشرة قبل ذكر أي مواصفة.',
    phoneAccessoriesCase: 'شاحن 33W يشحن 50% في 25 دقيقة بأمان قبل خروجك من البيت.',
    channelsFocus: 'فيسبوك، تيك توك، إنستغرام',
    pitfallAndFix: 'الثغرة: سرد المواصفات أولاً. الحل: جملة نتيجة ثم أمان.',
  ),
  MarketingPage(
    pageNumber: 2,
    thinker: 'أصل التسويق ونفسية الزبون',
    title: 'حماية جهاز غالٍ بقطعة بسيطة',
    coreIdea: 'الإكسسوار منخفض السعر يحمي هاتفاً مرتفع القيمة.',
    trick: 'قارن ثمن الإكسسوار بكلفة عطل أو كسر الهاتف.',
    phoneAccessoriesCase: 'واقي شاشة أو غطاء يحمي هاتفك من صدمة أو كسر مكلف.',
    channelsFocus: 'فيسبوك ماركت بليس، واتساب',
    pitfallAndFix: 'الثغرة: التركيز على السعر الرخيص فقط. الحل: إبراز الحماية.',
  ),
  MarketingPage(
    pageNumber: 3,
    thinker: 'ستيف جوبز',
    title: 'البساطة وحذف التردد',
    coreIdea: 'كثرة الخيارات تشتت الزبون وتؤخر قرار الشراء.',
    trick: 'قدّم خياراً أو باكاً واضحاً ومناسباً لموديل الهاتف.',
    phoneAccessoriesCase: 'باك جاهز: شاحن سريع + كابل مقوى متوافق مع هاتف الزبون.',
    channelsFocus: 'إنستغرام، واتساب، فيسبوك',
    pitfallAndFix: 'الثغرة: عرض عشرات الموديلات معاً. الحل: عرض واضح واحد.',
  ),
  MarketingPage(
    pageNumber: 4,
    thinker: 'ستيف جوبز',
    title: 'التفاصيل والاختبار الحقيقي',
    coreIdea: 'الجودة المرئية واللمسية تبني ثقة فورية.',
    trick: 'اعرض اختباراً عملياً قصيراً أو تصويراً واقعياً من يدك.',
    phoneAccessoriesCase: 'اختبار مرونة الكابل أو مقاومة البصمات على واقي الشاشة.',
    channelsFocus: 'تيك توك، إنستغرام ريلز، يوتيوب شورتس',
    pitfallAndFix: 'الثغرة: صور مأخوذة من الإنترنت. الحل: تصوير حقيقي واضح.',
  ),
  MarketingPage(
    pageNumber: 5,
    thinker: 'سيث غودين',
    title: 'كن ملحوظاً واستهدف شريحة محددة',
    coreIdea: 'المحتوى المألوف يُتجاهل؛ التخصيص لشريحة معينة يجذب الانتباه.',
    trick: 'خاطب فئة واضحة: سائقين، طلبة، أو لاعبي ألعاب.',
    phoneAccessoriesCase: 'شاحن سيارة للرحلات أو كابل زاوية 90 درجة للألعاب.',
    channelsFocus: 'تيك توك، مجموعات فيسبوك، تلغرام',
    pitfallAndFix: 'الثغرة: خطاب عام للجميع. الحل: تحديد الفئة والموديل.',
  ),
  MarketingPage(
    pageNumber: 6,
    thinker: 'أليكس هرموزي',
    title: 'عرض عالي القيمة دون حرق الربح',
    coreIdea: 'زد القيمة المضافة عبر باكات أو ضمان بدل خفض السعر عشوائياً.',
    trick: 'اربط منتجاً أساسياً بقطعة مكملة أو ضمان استبدال واضح.',
    phoneAccessoriesCase: 'شاحن + كابل مع تنظيم أسلاك أو توضيح الدفع عند الاستلام.',
    channelsFocus: 'فيسبوك، واتساب، إعلانات فيديوهات',
    pitfallAndFix: 'الثغرة: تخفيضات تقتل الهامش. الحل: بناء باك متكامل.',
  ),
  MarketingPage(
    pageNumber: 7,
    thinker: 'أليكس هرموزي',
    title: 'اختبار الخطافات (Hooks)',
    coreIdea: 'النتائج تأتي من اختبار عدة بدايات لا من منشور واحد.',
    trick: 'جرّب 3 بدايات مختلفة لنفس المنتج وقِس التفاعل.',
    phoneAccessoriesCase: 'بداية عن بطء الشحن، أو تلف الكابل، أو سرعة التوصيل.',
    channelsFocus: 'تيك توك، إنستغرام، إعلانات فيديوهات',
    pitfallAndFix: 'الثغرة: الحكم من تجربة واحدة. الحل: اختبار عدة بدايات.',
  ),
  MarketingPage(
    pageNumber: 8,
    thinker: 'روبرت سيالديني',
    title: 'الدليل الاجتماعي والندرة الحقيقية',
    coreIdea: 'الناس تتبع الأدلة الواقعية وتتحرك عند محدودية الكمية الفعلية.',
    trick: 'اعرض تجهيز الطرود للولايات والكمية المتبقية الحقيقية.',
    phoneAccessoriesCase: 'إظهار طرود جاهزة أو تنبيه الكمية المحدودة في المخزون.',
    channelsFocus: 'واتساب، تلغرام، إنستغرام',
    pitfallAndFix: 'الثغرة: ندرة وهمية أو تقييمات مزيفة. الحل: أرقام حقيقية.',
  ),
  MarketingPage(
    pageNumber: 9,
    thinker: 'يوجين شوارتز',
    title: 'مستويات وعي الزبون',
    coreIdea: 'رسالة من يبحث عن السعر تختلف عمن لا يعرف سبب المشكلة.',
    trick: 'اشرح المشكلة والحل لمن لا يعرفها، وقدّم السعر والتوفر لمن يريد الشراء.',
    phoneAccessoriesCase: 'شرح سبب بطء الشحن قبل عرض الشاحن السريع وسعره.',
    channelsFocus: 'فيسبوك، يوتيوب، إعلانات فيديوهات',
    pitfallAndFix: 'الثغرة: عرض السعر فقط لجمهور غير مهيأ. الحل: ترتيب الرسالة.',
  ),
  MarketingPage(
    pageNumber: 10,
    thinker: 'غاري هالفرت ودونالد ميلر',
    title: 'وضوح الرسالة ودعوة فعل مباشرة (CTA)',
    coreIdea: 'الوضوح يربح؛ اجعل الزبون يفهم العرض والخطوة التالية في ثوانٍ.',
    trick: 'خاطب شخصاً واحداً بلغة مباشرة واكتب ماذا يفعل للطلب.',
    phoneAccessoriesCase: 'أرسل موديل هاتفك والولاية لتأكيد التوافق ونوع التوصيل.',
    channelsFocus: 'واتساب، ماركت بليس، رسائل الصفحات',
    pitfallAndFix: 'الثغرة: عبارات مبهمة بلا خطوة طلب. الحل: CTA واضح.',
  ),
  MarketingPage(
    pageNumber: 11,
    thinker: 'روري ساذرلاند',
    title: 'إعادة التأطير وإشارات الثقة',
    coreIdea: 'التفاصيل الصغيرة والرد السريع الواضح يرفعان الثقة ويقللان التردد.',
    trick: 'قدّم التوصيل كراحة وصول الطلب للمكتب أو المنزل بوضوح تام.',
    phoneAccessoriesCase: 'تأكيد السعر النهائي والتوصيل قبل الإرسال لتقليل المرتجعات.',
    channelsFocus: 'واتساب، تلغرام، متابعة الطلبيات',
    pitfallAndFix: 'الثغرة: غموض كلفة التوصيل. الحل: توضيح المجموع مسبقاً.',
  ),
  MarketingPage(
    pageNumber: 12,
    thinker: 'القنوات الاجتماعية والبحث',
    title: 'فيسبوك، ماركت بليس، إنستغرام، ويوتيوب',
    coreIdea: 'لكل منصة دور: ماركت بليس للطلب المباشر، تيك توك/ريلز للحركة، يوتيوب للمقارنات.',
    trick: 'طابق شكل المحتوى مع هدف المنصة دون نسخ أعمى.',
    phoneAccessoriesCase: 'ماركت بليس: سعر وولاية واضحة. ريلز: تجربة المنتج. يوتيوب: مقارنة.',
    channelsFocus: 'فيسبوك، ماركت بليس، إنستغرام، يوتيوب',
    pitfallAndFix: 'الثغرة: نشر نص واحد في كل القنوات. الحل: تخصيص العنوان.',
  ),
  MarketingPage(
    pageNumber: 13,
    thinker: 'القنوات المباشرة والإعلانات',
    title: 'واتساب، تلغرام، وإعلانات الفيديو',
    coreIdea: 'واتساب وتلغرام للإغلاق والعروض المركزة، والفيديو يتبع: خطاف ← مشكلة ← حل ← طلب.',
    trick: 'اجعل فيديو الإعلان 15–30 ثانية مع خطاف قوي في أول 3 ثوانٍ.',
    phoneAccessoriesCase: 'إعلان قصير لمشكلة نفاد البطارية ثم الحل والطلب عبر واتساب/تلغرام.',
    channelsFocus: 'واتساب، تلغرام، إعلانات فيديوهات، تيك توك',
    pitfallAndFix: 'الثغرة: مقدمة بطيئة أو صرف بلا تتبع. الحل: خطاف سريع وحساب ربح.',
  ),
  MarketingPage(
    pageNumber: 14,
    thinker: 'المخزون وتقليل المرتجعات',
    title: 'تحريك الراكد ومنع المرتجعات (Retour)',
    coreIdea: 'المنتج الراكد يجمّد السيولة، والمرتجع يستنزف الوقت والربح.',
    trick: 'ادمج الراكد في باك مطلوب، وأكّد الموديل ونوع التوصيل قبل الشحن.',
    phoneAccessoriesCase: 'باك غطاء أو واقي شاشة قليل الحركة مع شاحن أو كابل سريع.',
    channelsFocus: 'واتساب، تلغرام، إدارة المخزون',
    pitfallAndFix: 'الثغرة: شحن طلبات غير مؤكدة. الحل: تأكيد واضح قبل الإرسال.',
  ),
  MarketingPage(
    pageNumber: 15,
    thinker: 'التصميم الإعلاني',
    title: 'مخطط صورة إعلانية واحدة واضحة',
    coreIdea: 'الصورة الإعلانية الفعالة تركز على عنصر واحد واضح دون ازدحام بصري.',
    trick: 'قسّم الصورة إلى 3 عناصر: صورة حقيقية للمنتج + فائدة قصيرة + عرض/طلب واضح.',
    phoneAccessoriesCase: 'صورة شاحن أو سماعة نظيفة + جملة فائدة + توصيل ودفع عند الاستلام.',
    channelsFocus: 'فيسبوك، إنستغرام، ماركت بليس، إعلانات فيديوهات',
    pitfallAndFix: 'الثغرة: حشو نصوص كثيرة في الصورة. الحل: مساحة فارغة وخط مقروء.',
  ),
];
class MainDashboardShell extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onToggleDarkMode;

  const MainDashboardShell({
    super.key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
  });

  @override
  State<MainDashboardShell> createState() => _MainDashboardShellState();
}

class _MainDashboardShellState extends State<MainDashboardShell> {
  int _currentIndex = 0;
  bool _isLocked = true;
  final _pinInputCtrl = TextEditingController();

  AppSettings _settings = AppSettings();

  List<String> _categories = [
    'شواحن',
    'كابلات',
    'سماعات',
    'أغطية',
    'واقي شاشة',
    'باور بانك',
    'أخرى',
  ];
  List<String> _supplierCategories = [...kDefaultSupplierCategories];

  String _selectedCategoryFilter = 'الكل';
  String _inventorySearch = '';
  String _orderStatusFilter = 'الكل';

  List<ProductItem> _products = [];
  List<WilayaRate> _wilayas = [];
  List<PartnerItem> _partners = [];
  List<SupplierItem> _suppliers = [];
  List<DebtRecord> _debts = [];
  List<OrderRecord> _orders = [];
  List<BlacklistedCustomer> _blacklist = [];
  List<ReviewRecord> _reviews = [];
  List<CouponItem> _coupons = [];
  List<String> _activityLog = [];

  String? _bannerMessage;
  bool _bannerIsError = false;

  // متحكمات إضافة المنتج والفئة
  final _prodSkuCtrl = TextEditingController();
  final _prodNameCtrl = TextEditingController();
  final _newCatCtrl = TextEditingController();
  final _wholesaleCtrl = TextEditingController();
  final _sellCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();
  final _minAlertCtrl = TextEditingController(text: '5');
  final _prodSupplierCtrl = TextEditingController();
  final _prodLastPriceCtrl = TextEditingController();
  final _prodDaysIdleCtrl = TextEditingController(text: '2');
  String _formCategory = 'شواحن';

  // متحكمات حاسبة الطلبيات
  String? _calcProductId;
  int _calcQty = 1;
  int _calcWilayaCode = 16;
  String _calcDeliveryType = 'stopdesk';
  String? _calcPartnerId;
  double _calcCommission = 150;
  final _calcCustomerPhoneCtrl = TextEditingController();
  final _calcTrackingCodeCtrl = TextEditingController();
  String _calcSourceChannel = 'فيسبوك';
  String _calcCouponCode = '';

  String _wilayaSearch = '';
  int _marketingPageIdx = 0;
  String? _promoProductId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _pinInputCtrl.dispose();
    _prodSkuCtrl.dispose();
    _prodNameCtrl.dispose();
    _newCatCtrl.dispose();
    _wholesaleCtrl.dispose();
    _sellCtrl.dispose();
    _qtyCtrl.dispose();
    _minAlertCtrl.dispose();
    _prodSupplierCtrl.dispose();
    _prodLastPriceCtrl.dispose();
    _prodDaysIdleCtrl.dispose();
    _calcCustomerPhoneCtrl.dispose();
    _calcTrackingCodeCtrl.dispose();
    super.dispose();
  }

  void _showBanner(String msg, {bool isError = false}) {
    setState(() {
      _bannerMessage = msg;
      _bannerIsError = isError;
    });
  }

  void _copyText(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    _showBanner('تم نسخ $label إلى الحافظة بنجاح.');
  }

  List<WilayaRate> _defaultWilayas() {
    return List.generate(kWilayaNames.length, (i) {
      final code = i + 1;
      final isSouth = [1, 11, 33, 37, 49, 50, 52, 53, 54, 56].contains(code);
      return WilayaRate(
        code: code,
        name: kWilayaNames[i],
        stopDesk: isSouth ? 750.0 : 450.0,
        domicile: isSouth ? 1100.0 : 700.0,
        returnRate: isSouth ? 14.0 : 6.0,
        packagingCost: 80.0,
      );
    });
  }

  void _seedDemoData() {
    _categories = ['شواحن', 'كابلات', 'سماعات', 'أغطية', 'واقي شاشة', 'باور بانك', 'أخرى'];
    _supplierCategories = [...kDefaultSupplierCategories];
    _formCategory = 'شواحن';
    _selectedCategoryFilter = 'الكل';

    _products = [
      ProductItem(
        id: 'p1',
        sku: 'CHG-33W',
        name: 'شاحن سريع 33W PD',
        category: 'شواحن',
        wholesalePrice: 1100,
        sellPrice: 2100,
        quantity: 18,
        minAlert: 5,
        soldCount: 24,
        cheapestSupplierName: 'مؤسسة النور العلمة',
        lastPurchasePrice: 1100,
        lastPurchaseDate: '2026-11-15',
        daysSinceLastSale: 1,
      ),
      ProductItem(
        id: 'p2',
        sku: 'CBL-TC01',
        name: 'كابل Type-C مقوى نايلون',
        category: 'كابلات',
        wholesalePrice: 450,
        sellPrice: 950,
        quantity: 4,
        minAlert: 5,
        soldCount: 31,
        cheapestSupplierName: 'شركة التنين - شينزن الصين',
        lastPurchasePrice: 420,
        lastPurchaseDate: '2026-11-10',
        daysSinceLastSale: 0,
      ),
      ProductItem(
        id: 'p3',
        sku: 'AUD-ANC2',
        name: 'سماعات لاسلكية ANC',
        category: 'سماعات',
        wholesalePrice: 1800,
        sellPrice: 3200,
        quantity: 10,
        minAlert: 4,
        soldCount: 12,
        cheapestSupplierName: 'مؤسسة النور العلمة',
        lastPurchasePrice: 1800,
        lastPurchaseDate: '2026-11-05',
        daysSinceLastSale: 4,
      ),
      ProductItem(
        id: 'p4',
        sku: 'CAS-OLD9',
        name: 'غطاء سيليكون موديل قديم',
        category: 'أغطية',
        wholesalePrice: 300,
        sellPrice: 650,
        quantity: 9,
        minAlert: 4,
        soldCount: 2,
        cheapestSupplierName: 'ورشة البليدة للتغليف',
        lastPurchasePrice: 300,
        lastPurchaseDate: '2026-09-20',
        daysSinceLastSale: 36,
      ),
    ];

    _wilayas = _defaultWilayas();

    _partners = [
      PartnerItem(id: 'pt1', name: 'عشير صلاح الدين', role: 'شريك', sharePercent: 25, earnedCommission: 600),
      PartnerItem(id: 'pt2', name: 'بوعبسة عزالدين', role: 'مؤسس شركة', sharePercent: 25, earnedCommission: 600),
      PartnerItem(id: 'pt3', name: 'يوسف بالعربي', role: 'مدير قسم مبيعات', sharePercent: 25, earnedCommission: 600),
      PartnerItem(id: 'pt4', name: 'عزيرية قويدر', role: 'رئيس قسم تسويق', sharePercent: 25, earnedCommission: 600),
    ];

    _suppliers = [
      SupplierItem(
        id: 'sup1',
        name: 'مؤسسة النور للجملة',
        phone: '0550123456',
        category: 'مورد إكسسوارات',
        isForeign: false,
        wilayaName: 'سطيف',
        addressOrCountry: 'شارع دبي، العلمة',
        lastPurchasePrice: 1100,
        lastPurchaseDate: '2026-11-15',
      ),
      SupplierItem(
        id: 'sup2',
        name: 'Shenzhen Tech Co',
        phone: '+8613800138000',
        category: 'مورد شرائح وإستصلاح هواتف',
        isForeign: true,
        wilayaName: '',
        addressOrCountry: 'الصين - شينزن',
        lastPurchasePrice: 420,
        lastPurchaseDate: '2026-11-10',
      ),
    ];

    _debts = [
      DebtRecord(
        id: 'd1',
        partyType: 'customer',
        partyName: 'محل الهواتف الذكية - مستغانم',
        phone: '0661998877',
        totalAmount: 18000,
        paidAmount: 10000,
        note: 'باقي دفعة شواحن وكابلات',
        dateStr: '2026-11-20',
      ),
      DebtRecord(
        id: 'd2',
        partyType: 'supplier',
        partyName: 'مؤسسة النور للجملة',
        phone: '0550123456',
        totalAmount: 45000,
        paidAmount: 30000,
        note: 'مستحقات فاتورة السماعات',
        dateStr: '2026-11-18',
      ),
    ];

    _coupons = [
      CouponItem(code: 'VIP100', discountValue: 100, note: 'خصم 100 دج لإعادة الشراء'),
      CouponItem(code: 'DZ250', discountValue: 250, note: 'خصم 250 دج للباك'),
    ];

    _blacklist = [
      BlacklistedCustomer(
        phone: '0770001122',
        nameOrNote: 'زبون متردد',
        wilayaName: 'الجزائر',
        reason: 'رفض الاستلام مرتين دون رد على الهاتف',
      ),
    ];

    _reviews = [
      ReviewRecord(
        id: 'rev1',
        subjectType: 'منتج',
        targetName: 'شاحن سريع 33W PD',
        rating: 5,
        comment: 'شحن سريع جداً وأصلي، وصلني للمكتب في 24 ساعة.',
        featuredSocialProof: true,
      ),
    ];

    _orders = [
      OrderRecord(
        id: 'ord-1',
        productName: 'شاحن سريع 33W PD',
        category: 'شواحن',
        customerPhone: '0555443322',
        sourceChannel: 'فيسبوك',
        trackingCode: 'YAL-894512',
        parcelStatus: 'مسلم',
        wilayaName: 'الجزائر',
        deliveryType: 'مكتب (Stop Desk)',
        qty: 2,
        shippingCost: 450,
        commission: 150,
        netProfit: 1850,
        finalPrice: 4650,
        partnerName: 'بوعبسة عزالدين',
        dateStr: '2026-11-26',
      ),
      OrderRecord(
        id: 'ord-2',
        productName: 'كابل Type-C مقوى نايلون',
        category: 'كابلات',
        customerPhone: '0662112233',
        sourceChannel: 'تيك توك',
        trackingCode: 'ZR-774120',
        parcelStatus: 'مؤكد',
        wilayaName: 'وهران',
        deliveryType: 'منزل (Domicile)',
        qty: 3,
        shippingCost: 700,
        commission: 150,
        netProfit: 1350,
        finalPrice: 3550,
        partnerName: 'يوسف بالعربي',
        dateStr: '2026-11-27',
      ),
    ];

    _activityLog = [
      'تهيئة نظام AccFlow DZ المتكامل - المبرمج AZEDDIN BOABCA',
      'تسجيل طلبية مسلمة: شاحن سريع 33W PD (YAL-894512)',
    ];

    _calcProductId = _products.first.id;
    _calcPartnerId = _partners.first.id;
    _promoProductId = _products.first.id;
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('accflow_dz_pro_v2');
    if (raw == null || raw.isEmpty) {
      setState(() {
        _seedDemoData();
        _isLocked = _settings.lockEnabled;
      });
      await _saveData();
      return;
    }

    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      setState(() {
        if (map['settings'] != null) {
          _settings = AppSettings.fromJson(map['settings'] as Map<String, dynamic>);
        }
        _isLocked = _settings.lockEnabled;

        final cats = (map['categories'] as List<dynamic>?)?.map((e) => e.toString()).toList();
        if (cats != null && cats.isNotEmpty) _categories = cats;

        final supCats = (map['supplierCategories'] as List<dynamic>?)?.map((e) => e.toString()).toList();
        if (supCats != null && supCats.isNotEmpty) _supplierCategories = supCats;

        _products = (map['products'] as List<dynamic>?)
                ?.map((e) => ProductItem.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];

        final wils = (map['wilayas'] as List<dynamic>?)
                ?.map((e) => WilayaRate.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];
        _wilayas = wils.length == 58 ? wils : _defaultWilayas();

        _partners = (map['partners'] as List<dynamic>?)
                ?.map((e) => PartnerItem.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];

        _suppliers = (map['suppliers'] as List<dynamic>?)
                ?.map((e) => SupplierItem.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];

        _debts = (map['debts'] as List<dynamic>?)
                ?.map((e) => DebtRecord.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];

        _orders = (map['orders'] as List<dynamic>?)
                ?.map((e) => OrderRecord.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];

        _blacklist = (map['blacklist'] as List<dynamic>?)
                ?.map((e) => BlacklistedCustomer.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];

        _reviews = (map['reviews'] as List<dynamic>?)
                ?.map((e) => ReviewRecord.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];

        _coupons = (map['coupons'] as List<dynamic>?)
                ?.map((e) => CouponItem.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];

        _activityLog = (map['activityLog'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];

        if (_products.isNotEmpty) {
          _calcProductId ??= _products.first.id;
          _promoProductId ??= _products.first.id;
        }
        if (_partners.isNotEmpty) _calcPartnerId ??= _partners.first.id;
      });
    } catch (_) {
      setState(() => _seedDemoData());
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final payload = {
      'settings': _settings.toJson(),
      'categories': _categories,
      'supplierCategories': _supplierCategories,
      'products': _products.map((e) => e.toJson()).toList(),
      'wilayas': _wilayas.map((e) => e.toJson()).toList(),
      'partners': _partners.map((e) => e.toJson()).toList(),
      'suppliers': _suppliers.map((e) => e.toJson()).toList(),
      'debts': _debts.map((e) => e.toJson()).toList(),
      'orders': _orders.map((e) => e.toJson()).toList(),
      'blacklist': _blacklist.map((e) => e.toJson()).toList(),
      'reviews': _reviews.map((e) => e.toJson()).toList(),
      'coupons': _coupons.map((e) => e.toJson()).toList(),
      'activityLog': _activityLog,
    };
    await prefs.setString('accflow_dz_pro_v2', jsonEncode(payload));
  }

  void _logAction(String entry) {
    final now = TimeOfDay.now();
    final stamp = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    _activityLog.insert(0, '[$stamp] $entry');
    if (_activityLog.length > 100) _activityLog = _activityLog.sublist(0, 100);
  }

  // مؤشرات الربح والتحليل
  List<OrderRecord> get _activeOrders => _orders.where((o) => o.parcelStatus != 'مرتجع').toList();
  double get _totalSales => _activeOrders.fold(0, (sum, o) => sum + o.finalPrice);
  double get _netProfit => _activeOrders.fold(0, (sum, o) => sum + o.netProfit);
  double get _wholesaleCapital => _products.fold(0, (sum, p) => sum + (p.wholesalePrice * p.quantity));
  int get _lowStockCount => _products.where((p) => p.isLowStock).length;
  int get _stagnantCount => _products.where((p) => p.isStagnant30Days).length;

  Map<String, double> get _profitByCategory {
    final map = <String, double>{};
    for (final o in _activeOrders) {
      map[o.category] = (map[o.category] ?? 0) + o.netProfit;
    }
    return map;
  }

  Map<String, double> get _profitBySource {
    final map = <String, double>{};
    for (final o in _activeOrders) {
      map[o.sourceChannel] = (map[o.sourceChannel] ?? 0) + o.netProfit;
    }
    return map;
  }

  double get _customerDebtsTotal =>
      _debts.where((d) => d.partyType == 'customer').fold(0, (s, d) => s + d.remainingAmount);

  double get _supplierDebtsTotal =>
      _debts.where((d) => d.partyType == 'supplier').fold(0, (s, d) => s + d.remainingAmount);

  String _fmt(double v) => '${v.toStringAsFixed(0)} دج';
    void _unlockWithPin() {
    if (_pinInputCtrl.text.trim() == _settings.pinCode) {
      setState(() {
        _isLocked = false;
        _pinInputCtrl.clear();
      });
      _showBanner('تم فتح النظام بنجاح.');
    } else {
      _showBanner('رمز الدخول غير صحيح. الافتراضي: ${_settings.pinCode}', isError: true);
    }
  }

  void _openQuickSettingsDialog() {
    final pinCtrl = TextEditingController(text: _settings.pinCode);
    final goalCtrl = TextEditingController(text: _settings.monthlySalesGoal.toStringAsFixed(0));
    final trackCtrl = TextEditingController(text: _settings.trackingBaseUrl);
    bool lockOn = _settings.lockEnabled;
    bool pwaOn = _settings.pwaReady;

    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('إعدادات الأمان، الهدف، والراحة', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('حماية بكلمة سر عند الفتح', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800)),
                  value: lockOn,
                  onChanged: (v) => lockOn = v,
                ),
                TextField(
                  controller: pinCtrl,
                  keyboardType: TextInputType.number,
                  decoration: _inputDeco('رمز الدخول (الافتراضي: 2005)'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: goalCtrl,
                  keyboardType: TextInputType.number,
                  decoration: _inputDeco('هدف المبيعات الشهري (دج)'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: trackCtrl,
                  decoration: _inputDeco('رابط التتبع الأساسي (مثال: https://yalidine.com/track/)'),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('جاهزية التثبيت كـ PWA / شاشة رئيسية', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800)),
                  value: pwaOn,
                  onChanged: (v) => pwaOn = v,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _settings.lockEnabled = lockOn;
                  _settings.pinCode = pinCtrl.text.trim().isEmpty ? '2005' : pinCtrl.text.trim();
                  _settings.monthlySalesGoal = double.tryParse(goalCtrl.text.trim()) ?? _settings.monthlySalesGoal;
                  _settings.trackingBaseUrl = trackCtrl.text.trim().isEmpty
                      ? 'https://yalidine.com/track/'
                      : trackCtrl.text.trim();
                  _settings.pwaReady = pwaOn;
                  _logAction('تحديث إعدادات الأمان والهدف الشهري');
                });
                _saveData();
                _showBanner('تم حفظ الإعدادات بنجاح.');
                Navigator.pop(ctx);
              },
              child: const Text('حفظ'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLockScreen() {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: _card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock_outline, size: 42, color: Color(0xFF059669)),
                  const SizedBox(height: 10),
                  const Text(
                    'AccFlow DZ - قفل البيانات المالية',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'أدخل رمز المرور للوصول إلى المخزون، الطلبيات، والديون',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11.5, color: Colors.grey),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _pinInputCtrl,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    onSubmitted: (_) => _unlockWithPin(),
                    decoration: _inputDeco('رمز المرور (2005)'),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _unlockWithPin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF059669),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('دخول', style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLocked) {
      return _buildLockScreen();
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('AccFlow DZ', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
            Text(
              '58 ولاية • شحن • موردون وديون • شركاء • تسويق',
              style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: widget.isDarkMode ? 'الوضع النهاري' : 'الوضع الليلي',
            onPressed: () => widget.onToggleDarkMode(!widget.isDarkMode),
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
          ),
          IconButton(
            tooltip: 'الإعدادات والقفل',
            onPressed: _openQuickSettingsDialog,
            icon: const Icon(Icons.settings),
          ),
          if (_settings.lockEnabled)
            IconButton(
              tooltip: 'قفل الآن',
              onPressed: () => setState(() => _isLocked = true),
              icon: const Icon(Icons.lock),
            ),
          IconButton(
            tooltip: 'استعادة التجريبية',
            onPressed: () {
              setState(() => _seedDemoData());
              _saveData();
              _showBanner('تمت استعادة البيانات التجريبية.');
            },
            icon: const Icon(Icons.restore),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              children: [
                _navChip(0, 'لوحة التحكم'),
                _navChip(1, 'المخزون (SKU)'),
                _navChip(2, 'الطلبيات والشحن'),
                _navChip(3, 'الموردون والديون'),
                _navChip(4, '58 ولاية والإرجاع'),
                _navChip(5, 'الشركاء والتقييمات'),
                _navChip(6, 'واتساب والكوبونات'),
                _navChip(7, 'عقليات التسويق (15 ص)'),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          if (_bannerMessage != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _bannerIsError ? const Color(0xFFFFF1F2) : const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _bannerIsError ? const Color(0xFFFECDD3) : const Color(0xFFA7F3D0),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _bannerMessage!,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: _bannerIsError ? const Color(0xFFBE123C) : const Color(0xFF047857),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _bannerMessage = null),
                    child: const Text('إغلاق', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
            ),
          Expanded(child: _buildCurrentTab()),
          _buildDeveloperFooter(),
        ],
      ),
    );
  }

  Widget _navChip(int index, String label) {
    final active = _currentIndex == index;
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w800,
            color: active ? Colors.white : null,
          ),
        ),
        selected: active,
        selectedColor: const Color(0xFF0F172A),
        showCheckmark: false,
        onSelected: (_) => setState(() => _currentIndex = index),
      ),
    );
  }

  Widget _buildDeveloperFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.black12))),
      child: const Wrap(
        alignment: WrapAlignment.spaceBetween,
        spacing: 10,
        runSpacing: 4,
        children: [
          Text('المبرمج: AZEDDIN BOABCA', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
          Text(
            'للتواصل أو التعديلات والإضافات: boabssaboabssa@gmail.com',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF059669)),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentTab() {
    switch (_currentIndex) {
      case 0:
        return _buildDashboardTab();
      case 1:
        return _buildInventoryTab();
      case 2:
        return _buildOrdersAndShippingTab();
      case 3:
        return _buildSuppliersAndDebtsTab();
      case 4:
        return _buildWilayasAndReturnsTab();
      case 5:
        return _buildPartnersAndReviewsTab();
      case 6:
        return _buildWhatsappAndCouponsTab();
      case 7:
        return _buildMarketingBookTab();
      default:
        return _buildDashboardTab();
    }
  }
    String _buildWeeklyWhatsappSummary() {
    final topCat = _profitByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topSrc = _profitBySource.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return '''📊 *تقرير أسبوعي - AccFlow DZ*
• إجمالي المبيعات: ${_fmt(_totalSales)}
• صافي الأرباح: ${_fmt(_netProfit)}
• رأس مال المخزون: ${_fmt(_wholesaleCapital)}
• ديون الزبائن المتبقية: ${_fmt(_customerDebtsTotal)}
• ديون الموردين المتبقية: ${_fmt(_supplierDebtsTotal)}
• أعلى فئة ربحاً: ${topCat.isNotEmpty ? '${topCat.first.key} (${_fmt(topCat.first.value)})' : 'لا يوجد'}
• أعلى مصدر زبائن: ${topSrc.isNotEmpty ? '${topSrc.first.key} (${_fmt(topSrc.first.value)})' : 'لا يوجد'}
• منتجات راكدة (+30 يوم): $_stagnantCount | كمية محدودة: $_lowStockCount''';
  }

  Widget _buildDashboardTab() {
    final goal = math.max(1.0, _settings.monthlySalesGoal);
    final progress = (_totalSales / goal).clamp(0.0, 1.0);
    final catEntries = _profitByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final srcEntries = _profitBySource.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final stagnantItems = _products.where((p) => p.isStagnant30Days).toList();
    final reorderItems = _products.where((p) => p.isLowStock).toList();

    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        GridView.count(
          crossAxisCount: MediaQuery.of(context).size.width > 700 ? 4 : 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.5,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _kpiCard('إجمالي المبيعات', _fmt(_totalSales), const Color(0xFF0F172A)),
            _kpiCard('صافي الأرباح', _fmt(_netProfit), const Color(0xFF059669)),
            _kpiCard('رأس مال المخزون', _fmt(_wholesaleCapital), const Color(0xFF2563EB)),
            _kpiCard('ركود +30 يوم / نقص', '$_stagnantCount / $_lowStockCount', const Color(0xFFDC2626)),
          ],
        ),
        const SizedBox(height: 12),
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('الهدف الشهري للمبيعات', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13.5)),
                  Text('${(progress * 100).toStringAsFixed(1)}%', style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF059669))),
                ],
              ),
              const SizedBox(height: 6),
              LinearProgressIndicator(value: progress, minHeight: 9, borderRadius: BorderRadius.circular(6)),
              const SizedBox(height: 6),
              Text(
                'المحقق: ${_fmt(_totalSales)} من أصل ${_fmt(_settings.monthlySalesGoal)} (متوسط يومي مقترح: ${_fmt(_settings.monthlySalesGoal / 30)})',
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => _copyText(_buildWeeklyWhatsappSummary(), 'التقرير الأسبوعي للواتساب'),
                icon: const Icon(Icons.copy, size: 16),
                label: const Text('نسخ تقرير أسبوعي للشركاء (واتساب)', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('الأرباح حسب الفئة وحسب مصدر الزبون', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13.5)),
              const SizedBox(height: 8),
              ...catEntries.map((e) => _summaryLine('فئة: ${e.key}', _fmt(e.value), const Color(0xFF059669))),
              const Divider(),
              ...srcEntries.map((e) => _summaryLine('مصدر: ${e.key}', _fmt(e.value), const Color(0xFF2563EB))),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('اقتراح إعادة الطلب والمنتجات الراكدة (+30 يوم)', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13.5)),
              const SizedBox(height: 8),
              if (reorderItems.isEmpty && stagnantItems.isEmpty)
                const Text('لا توجد تنبيهات إعادة طلب أو ركود حالياً.', style: TextStyle(fontSize: 12))
              else ...[
                ...reorderItems.map(
                  (p) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '• إعادة طلب [${p.sku}] ${p.name}: يُقترح شراء ${p.suggestedReorderQty} وحدة (أرخص مورد: ${p.cheapestSupplierName})',
                      style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF2563EB)),
                    ),
                  ),
                ),
                ...stagnantItems.map(
                  (p) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '• راكد منذ ${p.daysSinceLastSale} يوماً: ${p.name} — مقترح دمج في باك، تخفيض، أو حذف لتفريغ السيولة.',
                      style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFFD97706)),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _kpiCard(String title, String value, Color color) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Colors.grey)),
          Text(value, style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w900, color: color)),
        ],
      ),
    );
  }

  Widget _summaryLine(String title, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: color)),
        ],
      ),
    );
  }
    void _addCustomCategory() {
    final raw = _newCatCtrl.text.trim();
    if (raw.isEmpty || _categories.contains(raw)) {
      _showBanner('أدخل اسم فئة جديد وغير مكرر.', isError: true);
      return;
    }
    setState(() {
      _categories.add(raw);
      _formCategory = raw;
      _newCatCtrl.clear();
      _logAction('إضافة فئة منتجات: $raw');
    });
    _saveData();
    _showBanner('تمت إضافة الفئة "$raw".');
  }

  void _addProduct() {
    final name = _prodNameCtrl.text.trim();
    final sku = _prodSkuCtrl.text.trim().isEmpty
        ? 'SKU-${_products.length + 101}'
        : _prodSkuCtrl.text.trim();
    final wholesale = double.tryParse(_wholesaleCtrl.text.trim()) ?? -1;
    final sell = double.tryParse(_sellCtrl.text.trim()) ?? -1;
    final qty = int.tryParse(_qtyCtrl.text.trim()) ?? -1;
    final minAlert = int.tryParse(_minAlertCtrl.text.trim()) ?? 5;
    final lastPrice = double.tryParse(_prodLastPriceCtrl.text.trim()) ?? wholesale;
    final daysIdle = int.tryParse(_prodDaysIdleCtrl.text.trim()) ?? 0;
    final supplier = _prodSupplierCtrl.text.trim().isEmpty
        ? 'مورد عام'
        : _prodSupplierCtrl.text.trim();

    if (name.isEmpty || wholesale < 0 || sell < 0 || qty < 0) {
      _showBanner('يرجى إدخال اسم المنتج والأسعار والكمية بشكل صحيح.', isError: true);
      return;
    }

    final item = ProductItem(
      id: 'p-${DateTime.now().millisecondsSinceEpoch}',
      sku: sku,
      name: name,
      category: _formCategory,
      wholesalePrice: wholesale,
      sellPrice: sell,
      quantity: qty,
      minAlert: minAlert,
      soldCount: 0,
      cheapestSupplierName: supplier,
      lastPurchasePrice: lastPrice,
      lastPurchaseDate: DateTime.now().toIso8601String().split('T').first,
      daysSinceLastSale: daysIdle,
    );

    setState(() {
      _products.add(item);
      _calcProductId ??= item.id;
      _promoProductId ??= item.id;
      _prodSkuCtrl.clear();
      _prodNameCtrl.clear();
      _wholesaleCtrl.clear();
      _sellCtrl.clear();
      _qtyCtrl.clear();
      _prodSupplierCtrl.clear();
      _prodLastPriceCtrl.clear();
      _prodDaysIdleCtrl.text = '0';
      _logAction('إضافة منتج [$sku]: $name');
    });
    _saveData();
    _showBanner('تمت إضافة المنتج "$name" إلى المخزون.');
  }

  Widget _buildInventoryTab() {
    final filtered = _products.where((p) {
      final matchesCat = _selectedCategoryFilter == 'الكل' || p.category == _selectedCategoryFilter;
      final q = _inventorySearch.trim().toLowerCase();
      final matchesQuery = q.isEmpty ||
          p.name.toLowerCase().contains(q) ||
          p.sku.toLowerCase().contains(q) ||
          p.cheapestSupplierName.toLowerCase().contains(q);
      return matchesCat && matchesQuery;
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('إضافة فئة جديدة', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13.5)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: TextField(controller: _newCatCtrl, decoration: _inputDeco('اسم الفئة الجديدة'))),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _addCustomCategory,
                    child: const Text('إضافة', style: TextStyle(fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('إضافة منتج جديد (مع SKU والمورد)', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: TextField(controller: _prodSkuCtrl, decoration: _inputDeco('رمز SKU / باركود'))),
                  const SizedBox(width: 8),
                  Expanded(flex: 2, child: TextField(controller: _prodNameCtrl, decoration: _inputDeco('اسم المنتج'))),
                ],
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _categories.contains(_formCategory) ? _formCategory : _categories.first,
                decoration: _inputDeco('الفئة'),
                items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 12)))).toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _formCategory = v);
                },
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: TextField(controller: _wholesaleCtrl, keyboardType: TextInputType.number, decoration: _inputDeco('سعر الجملة (دج)'))),
                  const SizedBox(width: 8),
                  Expanded(child: TextField(controller: _sellCtrl, keyboardType: TextInputType.number, decoration: _inputDeco('سعر البيع (دج)'))),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: TextField(controller: _qtyCtrl, keyboardType: TextInputType.number, decoration: _inputDeco('الكمية'))),
                  const SizedBox(width: 8),
                  Expanded(child: TextField(controller: _minAlertCtrl, keyboardType: TextInputType.number, decoration: _inputDeco('حد التنبيه'))),
                  const SizedBox(width: 8),
                  Expanded(child: TextField(controller: _prodDaysIdleCtrl, keyboardType: TextInputType.number, decoration: _inputDeco('أيام بلا بيع'))),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: TextField(controller: _prodSupplierCtrl, decoration: _inputDeco('أرخص مورد'))),
                  const SizedBox(width: 8),
                  Expanded(child: TextField(controller: _prodLastPriceCtrl, keyboardType: TextInputType.number, decoration: _inputDeco('آخر سعر شراء'))),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _addProduct,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF059669), foregroundColor: Colors.white),
                  child: const Text('حفظ المنتج', style: TextStyle(fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          onChanged: (v) => setState(() => _inventorySearch = v),
          decoration: _inputDeco('بحث سريع بالاسم أو SKU أو المورد...'),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ['الكل', ..._categories].map((cat) {
              final active = _selectedCategoryFilter == cat;
              return Padding(
                padding: const EdgeInsets.only(left: 6),
                child: ChoiceChip(
                  label: Text(cat, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800)),
                  selected: active,
                  onSelected: (_) => setState(() => _selectedCategoryFilter = cat),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 10),
        ...filtered.map(
          (p) => _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text('[${p.sku}] ${p.name}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13))),
                    Text(p.category, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF059669))),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'جملة: ${_fmt(p.wholesalePrice)} • بيع: ${_fmt(p.sellPrice)} • كمية: ${p.quantity} • مباع: ${p.soldCount}',
                  style: const TextStyle(fontSize: 11.5),
                ),
                Text(
                  'أرخص مورد: ${p.cheapestSupplierName} (${_fmt(p.lastPurchasePrice)} - ${p.lastPurchaseDate}) • بلا بيع: ${p.daysSinceLastSale}ي',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                if (p.isStagnant30Days)
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text('تنبيه: منتج راكد (+30 يوماً) — يُقترح تخفيضه أو دمجه أو حذفه.', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFFD97706))),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() => p.quantity = math.max(0, p.quantity - 1));
                        _saveData();
                      },
                      icon: const Icon(Icons.remove_circle_outline, size: 20),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() => p.quantity += 1);
                        _saveData();
                      },
                      icon: const Icon(Icons.add_circle_outline, size: 20),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() => _products.removeWhere((x) => x.id == p.id));
                        _saveData();
                      },
                      icon: const Icon(Icons.delete_outline, color: Color(0xFFDC2626), size: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
    ProductItem? get _selectedProduct => _products.isEmpty
      ? null
      : _products.firstWhere((p) => p.id == _calcProductId, orElse: () => _products.first);

  WilayaRate get _selectedWilaya =>
      _wilayas.firstWhere((w) => w.code == _calcWilayaCode, orElse: () => _wilayas.first);

  PartnerItem? get _selectedPartner => _partners.isEmpty
      ? null
      : _partners.firstWhere((p) => p.id == _calcPartnerId, orElse: () => _partners.first);

  CouponItem? get _matchedCoupon {
    final code = _calcCouponCode.trim().toUpperCase();
    if (code.isEmpty) return null;
    try {
      return _coupons.firstWhere((c) => c.code.toUpperCase() == code);
    } catch (_) {
      return null;
    }
  }

  double get _calcShippingCost =>
      _calcDeliveryType == 'domicile' ? _selectedWilaya.domicile : _selectedWilaya.stopDesk;
  double get _calcDiscount => _matchedCoupon?.discountValue ?? 0;
  double get _calcSubtotal => math.max(0.0, ((_selectedProduct?.sellPrice ?? 0) * _calcQty) - _calcDiscount);
  double get _calcWholesaleTotal => (_selectedProduct?.wholesalePrice ?? 0) * _calcQty;
  double get _calcNetProfit => _calcSubtotal - _calcWholesaleTotal - _calcCommission;
  double get _calcFinalCustomerPrice => _calcSubtotal + _calcShippingCost;

  void _confirmOrder() {
    final prod = _selectedProduct;
    if (prod == null || _calcQty <= 0 || prod.quantity < _calcQty) {
      _showBanner('تحقق من توفر المنتج والكمية المطلوبة.', isError: true);
      return;
    }

    final phone = _calcCustomerPhoneCtrl.text.trim();
    final isBlacklisted = phone.isNotEmpty && _blacklist.any((b) => b.phone == phone);
    if (isBlacklisted) {
      _showBanner('تنبيه: رقم الزبون ($phone) مدرج في قائمة الزبائن غير المردودين!', isError: true);
    }

    final partner = _selectedPartner;
    final rec = OrderRecord(
      id: 'ord-${DateTime.now().millisecondsSinceEpoch}',
      productName: prod.name,
      category: prod.category,
      customerPhone: phone,
      sourceChannel: _calcSourceChannel,
      couponCode: _matchedCoupon?.code ?? '',
      discountAmount: _calcDiscount,
      trackingCode: _calcTrackingCodeCtrl.text.trim(),
      parcelStatus: 'مؤكد',
      wilayaName: _selectedWilaya.name,
      deliveryType: _calcDeliveryType == 'domicile' ? 'منزل (Domicile)' : 'مكتب (Stop Desk)',
      qty: _calcQty,
      shippingCost: _calcShippingCost,
      commission: _calcCommission,
      netProfit: _calcNetProfit,
      finalPrice: _calcFinalCustomerPrice,
      partnerName: partner?.name ?? 'غير محدد',
      dateStr: DateTime.now().toIso8601String().split('T').first,
    );

    setState(() {
      prod.quantity -= _calcQty;
      prod.soldCount += _calcQty;
      prod.daysSinceLastSale = 0;
      if (partner != null) partner.earnedCommission += _calcCommission;
      _orders.insert(0, rec);
      _calcTrackingCodeCtrl.clear();
      _logAction('طلبية: ${prod.name} × $_calcQty (${_selectedWilaya.name}) - شريك: ${rec.partnerName}');
    });
    _saveData();
    _showBanner('تم تسجيل الطلبية بنجاح.');
  }

  Widget _buildOrdersAndShippingTab() {
    final phone = _calcCustomerPhoneCtrl.text.trim();
    final blackMatch = phone.isEmpty
        ? null
        : _blacklist.cast<BlacklistedCustomer?>().firstWhere((b) => b?.phone == phone, orElse: () => null);

    final visibleOrders = _orders.where((o) {
      if (_orderStatusFilter == 'الكل') return true;
      return o.parcelStatus == _orderStatusFilter;
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('حاسبة التسعير وتسجيل طلبية جديدة', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _products.any((p) => p.id == _calcProductId) ? _calcProductId : (_products.isNotEmpty ? _products.first.id : null),
                decoration: _inputDeco('المنتج'),
                items: _products.map((p) => DropdownMenuItem(value: p.id, child: Text('[${p.sku}] ${p.name} (${p.quantity})', style: const TextStyle(fontSize: 12)))).toList(),
                onChanged: (v) => setState(() => _calcProductId = v),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _calcCustomerPhoneCtrl,
                      keyboardType: TextInputType.phone,
                      onChanged: (_) => setState(() {}),
                      decoration: _inputDeco('رقم الزبون (مثال: 0550...)'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      initialValue: _calcQty.toString(),
                      keyboardType: TextInputType.number,
                      decoration: _inputDeco('الكمية'),
                      onChanged: (v) => setState(() => _calcQty = int.tryParse(v) ?? 1),
                    ),
                  ),
                ],
              ),
              if (blackMatch != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    '⚠️ تحذير: هذا الرقم مسجل كزبون غير مردود (${blackMatch.reason}) — يُنصح بطلب عربون.',
                    style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: Color(0xFFDC2626)),
                  ),
                ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: _calcWilayaCode,
                      decoration: _inputDeco('الولاية'),
                      items: _wilayas.map((w) => DropdownMenuItem(value: w.code, child: Text('${w.code} - ${w.name}', style: const TextStyle(fontSize: 12)))).toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _calcWilayaCode = v);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _calcDeliveryType,
                      decoration: _inputDeco('التوصيل'),
                      items: const [
                        DropdownMenuItem(value: 'stopdesk', child: Text('مكتب (Stop Desk)', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 'domicile', child: Text('منزل (Domicile)', style: TextStyle(fontSize: 12))),
                      ],
                      onChanged: (v) {
                        if (v != null) setState(() => _calcDeliveryType = v);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _partners.any((p) => p.id == _calcPartnerId) ? _calcPartnerId : (_partners.isNotEmpty ? _partners.first.id : null),
                      decoration: _inputDeco('الشريك الجالب للزبون'),
                      items: _partners.map((p) => DropdownMenuItem(value: p.id, child: Text('${p.name} (${p.role})', style: const TextStyle(fontSize: 11.5)))).toList(),
                      onChanged: (v) => setState(() => _calcPartnerId = v),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      initialValue: _calcCommission.toStringAsFixed(0),
                      keyboardType: TextInputType.number,
                      decoration: _inputDeco('عمولة الشريك (دج)'),
                      onChanged: (v) => setState(() => _calcCommission = double.tryParse(v) ?? 0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _calcSourceChannel,
                      decoration: _inputDeco('مصدر الزبون'),
                      items: kOrderSources.map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 12)))).toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _calcSourceChannel = v);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      onChanged: (v) => setState(() => _calcCouponCode = v),
                      decoration: _inputDeco('كوبون خصم (اختياري)'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _calcTrackingCodeCtrl,
                decoration: _inputDeco('كود التتبع (Yalidine / ZR Express...)'),
              ),
              const SizedBox(height: 10),
              _summaryLine('الخصم المطبق:', _fmt(_calcDiscount), const Color(0xFFD97706)),
              _summaryLine('الشحن للولاية:', _fmt(_calcShippingCost), const Color(0xFF2563EB)),
              _summaryLine('صافي الربح:', _fmt(_calcNetProfit), const Color(0xFF059669)),
              _summaryLine('السعر النهائي للزبون:', _fmt(_calcFinalCustomerPrice), const Color(0xFF0F172A)),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _confirmOrder,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF059669), foregroundColor: Colors.white),
                  child: const Text('تأكيد الطلبية', style: TextStyle(fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ['الكل', 'مؤكد', 'مسلم', 'مرتجع'].map((st) {
              return Padding(
                padding: const EdgeInsets.only(left: 6),
                child: ChoiceChip(
                  label: Text(st, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800)),
                  selected: _orderStatusFilter == st,
                  onSelected: (_) => setState(() => _orderStatusFilter = st),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),
        ...visibleOrders.map((o) {
          final trackUrl = '${_settings.trackingBaseUrl}${o.trackingCode}';
          return _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text('${o.productName} × ${o.qty}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13))),
                    DropdownButton<String>(
                      value: o.parcelStatus,
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(value: 'مؤكد', child: Text('مؤكد', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 'مسلم', child: Text('مسلم', style: TextStyle(fontSize: 12, color: Color(0xFF059669)))),
                        DropdownMenuItem(value: 'مرتجع', child: Text('مرتجع', style: TextStyle(fontSize: 12, color: Color(0xFFDC2626)))),
                      ],
                      onChanged: (v) {
                        if (v != null) {
                          setState(() => o.parcelStatus = v);
                          _saveData();
                        }
                      },
                    ),
                  ],
                ),
                Text(
                  'زبون: ${o.customerPhone.isEmpty ? 'غير مدون' : o.customerPhone} • ${o.wilayaName} • ${o.sourceChannel}',
                  style: const TextStyle(fontSize: 11.5),
                ),
                Text(
                  'شريك: ${o.partnerName} • عمولة: ${_fmt(o.commission)} • النهائي: ${_fmt(o.finalPrice)}',
                  style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700),
                ),
                if (o.trackingCode.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text('تتبع: ${o.trackingCode}', style: const TextStyle(fontSize: 11, color: Colors.blue))),
                      TextButton(
                        onPressed: () => _copyText(trackUrl, 'رابط التتبع (${o.trackingCode})'),
                        child: const Text('نسخ رابط التتبع', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
                      ),
                    ],
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }
    void _openAddSupplierDialog() {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final addrCtrl = TextEditingController();
    final newCatCtrl = TextEditingController();
    String cat = _supplierCategories.first;
    String wilaya = kWilayaNames[15]; // الجزائر
    bool isForeign = false;

    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: StatefulBuilder(
          builder: (ctx, setLocal) => AlertDialog(
            title: const Text('إضافة مورد جديد', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: nameCtrl, decoration: _inputDeco('اسم المورد / الشركة')),
                  const SizedBox(height: 8),
                  TextField(controller: phoneCtrl, keyboardType: TextInputType.phone, decoration: _inputDeco('رقم الهاتف')),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: cat,
                    decoration: _inputDeco('صنف المورد'),
                    items: _supplierCategories.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 11.5)))).toList(),
                    onChanged: (v) {
                      if (v != null) setLocal(() => cat = v);
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: TextField(controller: newCatCtrl, decoration: _inputDeco('صنف مورد جديد'))),
                      IconButton(
                        onPressed: () {
                          final nc = newCatCtrl.text.trim();
                          if (nc.isNotEmpty && !_supplierCategories.contains(nc)) {
                            setState(() => _supplierCategories.add(nc));
                            setLocal(() {
                              cat = nc;
                              newCatCtrl.clear();
                            });
                          }
                        },
                        icon: const Icon(Icons.add_circle, color: Color(0xFF059669)),
                      ),
                    ],
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('مورد خارج البلاد (صين / ألمانيا...)', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
                    value: isForeign,
                    onChanged: (v) => setLocal(() => isForeign = v),
                  ),
                  if (!isForeign)
                    DropdownButtonFormField<String>(
                      value: wilaya,
                      decoration: _inputDeco('الولاية'),
                      items: kWilayaNames.map((w) => DropdownMenuItem(value: w, child: Text(w, style: const TextStyle(fontSize: 12)))).toList(),
                      onChanged: (v) {
                        if (v != null) setLocal(() => wilaya = v);
                      },
                    ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: addrCtrl,
                    decoration: _inputDeco(isForeign ? 'الدولة والمدينة (مثال: الصين - شينزن أو ألمانيا)' : 'الشارع / الحي'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
              ElevatedButton(
                onPressed: () {
                  if (nameCtrl.text.trim().isEmpty) return;
                  setState(() {
                    _suppliers.add(
                      SupplierItem(
                        id: 'sup-${DateTime.now().millisecondsSinceEpoch}',
                        name: nameCtrl.text.trim(),
                        phone: phoneCtrl.text.trim(),
                        category: cat,
                        isForeign: isForeign,
                        wilayaName: isForeign ? '' : wilaya,
                        addressOrCountry: addrCtrl.text.trim(),
                      ),
                    );
                    _logAction('إضافة مورد: ${nameCtrl.text.trim()} ($cat)');
                  });
                  _saveData();
                  Navigator.pop(ctx);
                },
                child: const Text('حفظ'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openAddDebtDialog() {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final totalCtrl = TextEditingController();
    final paidCtrl = TextEditingController(text: '0');
    final noteCtrl = TextEditingController();
    String partyType = 'customer';

    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: StatefulBuilder(
          builder: (ctx, setLocal) => AlertDialog(
            title: const Text('تسجيل دين جديد', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: partyType,
                    decoration: _inputDeco('نوع الدين'),
                    items: const [
                      DropdownMenuItem(value: 'customer', child: Text('دين زبون (لنا عنده)', style: TextStyle(fontSize: 12))),
                      DropdownMenuItem(value: 'supplier', child: Text('دين مورد (علينا له)', style: TextStyle(fontSize: 12))),
                    ],
                    onChanged: (v) {
                      if (v != null) setLocal(() => partyType = v);
                    },
                  ),
                  const SizedBox(height: 8),
                  TextField(controller: nameCtrl, decoration: _inputDeco('الاسم')),
                  const SizedBox(height: 8),
                  TextField(controller: phoneCtrl, keyboardType: TextInputType.phone, decoration: _inputDeco('رقم الهاتف')),
                  const SizedBox(height: 8),
                  TextField(controller: totalCtrl, keyboardType: TextInputType.number, decoration: _inputDeco('المبلغ الإجمالي (دج)')),
                  const SizedBox(height: 8),
                  TextField(controller: paidCtrl, keyboardType: TextInputType.number, decoration: _inputDeco('المدفوع مسبقاً (دج)')),
                  const SizedBox(height: 8),
                  TextField(controller: noteCtrl, decoration: _inputDeco('ملاحظة')),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
              ElevatedButton(
                onPressed: () {
                  final total = double.tryParse(totalCtrl.text.trim()) ?? 0;
                  final paid = double.tryParse(paidCtrl.text.trim()) ?? 0;
                  if (nameCtrl.text.trim().isEmpty || total <= 0) return;
                  setState(() {
                    _debts.add(
                      DebtRecord(
                        id: 'd-${DateTime.now().millisecondsSinceEpoch}',
                        partyType: partyType,
                        partyName: nameCtrl.text.trim(),
                        phone: phoneCtrl.text.trim(),
                        totalAmount: total,
                        paidAmount: paid,
                        note: noteCtrl.text.trim(),
                        dateStr: DateTime.now().toIso8601String().split('T').first,
                      ),
                    );
                    _logAction('تسجيل دين ${partyType == 'customer' ? 'زبون' : 'مورد'}: ${nameCtrl.text.trim()}');
                  });
                  _saveData();
                  Navigator.pop(ctx);
                },
                child: const Text('حفظ'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuppliersAndDebtsTab() {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('الموردون (محلي وخارج البلاد)', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                  ElevatedButton.icon(
                    onPressed: _openAddSupplierDialog,
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('إضافة مورد', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ..._suppliers.map(
                (s) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(border: Border.all(color: Colors.black12), borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${s.name} • ${s.category}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12.5)),
                      Text('هاتف: ${s.phone} • المكان: ${s.locationLabel}', style: const TextStyle(fontSize: 11.5)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('ديون الزبائن والموردين', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                  ElevatedButton.icon(
                    onPressed: _openAddDebtDialog,
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('إضافة دين', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'متبقي ديون الزبائن: ${_fmt(_customerDebtsTotal)} • متبقي ديون الموردين: ${_fmt(_supplierDebtsTotal)}',
                style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: Color(0xFFDC2626)),
              ),
              const SizedBox(height: 8),
              ..._debts.map(
                (d) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(border: Border.all(color: Colors.black12), borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '[${d.partyType == 'customer' ? 'زبون' : 'مورد'}] ${d.partyName}',
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12.5),
                            ),
                            Text('الإجمالي: ${_fmt(d.totalAmount)} • المدفوع: ${_fmt(d.paidAmount)}', style: const TextStyle(fontSize: 11)),
                          ],
                        ),
                      ),
                      Text(
                        'باقي: ${_fmt(d.remainingAmount)}',
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: Color(0xFFDC2626)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWilayasAndReturnsTab() {
    final phoneBlackCtrl = TextEditingController();
    final reasonBlackCtrl = TextEditingController();
    final filteredWilayas = _wilayas.where((w) {
      final q = _wilayaSearch.trim();
      return q.isEmpty || w.name.contains(q) || w.code.toString().contains(q);
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('قائمة الزبائن غير المردودين (حظر / تنبيه قبل الشحن)', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13.5)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: TextField(controller: phoneBlackCtrl, keyboardType: TextInputType.phone, decoration: _inputDeco('رقم الهاتف'))),
                  const SizedBox(width: 8),
                  Expanded(child: TextField(controller: reasonBlackCtrl, decoration: _inputDeco('سبب الرفض'))),
                  IconButton(
                    onPressed: () {
                      if (phoneBlackCtrl.text.trim().isEmpty) return;
                      setState(() {
                        _blacklist.add(
                          BlacklistedCustomer(
                            phone: phoneBlackCtrl.text.trim(),
                            nameOrNote: '',
                            wilayaName: '',
                            reason: reasonBlackCtrl.text.trim().isEmpty ? 'رفض الاستلام سابقاً' : reasonBlackCtrl.text.trim(),
                          ),
                        );
                      });
                      _saveData();
                      phoneBlackCtrl.clear();
                      reasonBlackCtrl.clear();
                    },
                    icon: const Icon(Icons.block, color: Color(0xFFDC2626)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ..._blacklist.map(
                (b) => Text('• ${b.phone} — ${b.reason}', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFFDC2626))),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          onChanged: (v) => setState(() => _wilayaSearch = v),
          decoration: _inputDeco('بحث عن ولاية (1 إلى 58) وحاسبة خسارة الإرجاع...'),
        ),
        const SizedBox(height: 8),
        ...filteredWilayas.map(
          (w) => _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${w.code} - ${w.name}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                    Text(
                      w.needsDepositAlert ? '⚠️ اطلب عربوناً (مرتجع ${w.returnRate.toStringAsFixed(0)}%)' : 'مرتجع ${w.returnRate.toStringAsFixed(0)}%',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: w.needsDepositAlert ? const Color(0xFFDC2626) : const Color(0xFF059669)),
                    ),
                  ],
                ),
                Text('خسارة المرتجع التقديرية: ${_fmt(w.estimatedReturnLoss)} (ذهاب وإياب + تغليف)', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: w.stopDesk.toStringAsFixed(0),
                        keyboardType: TextInputType.number,
                        decoration: _inputDeco('مكتب'),
                        onChanged: (v) {
                          w.stopDesk = double.tryParse(v) ?? w.stopDesk;
                          _saveData();
                        },
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: TextFormField(
                        initialValue: w.domicile.toStringAsFixed(0),
                        keyboardType: TextInputType.number,
                        decoration: _inputDeco('منزل'),
                        onChanged: (v) {
                          w.domicile = double.tryParse(v) ?? w.domicile;
                          _saveData();
                        },
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: TextFormField(
                        initialValue: w.returnRate.toStringAsFixed(0),
                        keyboardType: TextInputType.number,
                        decoration: _inputDeco('مرتجع %'),
                        onChanged: (v) {
                          setState(() => w.returnRate = double.tryParse(v) ?? w.returnRate);
                          _saveData();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
    void _openPartnerDialog({PartnerItem? existing}) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final shareCtrl = TextEditingController(text: existing?.sharePercent.toStringAsFixed(0) ?? '25');
    String role = existing != null && kPartnerRoles.contains(existing.role) ? existing.role : kPartnerRoles.first;

    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: StatefulBuilder(
          builder: (ctx, setLocal) => AlertDialog(
            title: Text(existing == null ? 'إضافة شريك / عضو' : 'تعديل شريك / عضو', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: nameCtrl, decoration: _inputDeco('الاسم الكامل')),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: role,
                    decoration: _inputDeco('الصفة / الدور'),
                    items: kPartnerRoles.map((r) => DropdownMenuItem(value: r, child: Text(r, style: const TextStyle(fontSize: 12)))).toList(),
                    onChanged: (v) {
                      if (v != null) setLocal(() => role = v);
                    },
                  ),
                  const SizedBox(height: 8),
                  TextField(controller: shareCtrl, keyboardType: TextInputType.number, decoration: _inputDeco('نسبة الربح (%)')),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
              ElevatedButton(
                onPressed: () {
                  final name = nameCtrl.text.trim();
                  final share = double.tryParse(shareCtrl.text.trim()) ?? -1;
                  if (name.isEmpty || share < 0) return;
                  setState(() {
                    if (existing == null) {
                      _partners.add(PartnerItem(id: 'pt-${DateTime.now().millisecondsSinceEpoch}', name: name, role: role, sharePercent: share));
                    } else {
                      existing.name = name;
                      existing.role = role;
                      existing.sharePercent = share;
                    }
                    _logAction('حفظ بيانات عضو/شريك: $name ($role - $share%)');
                  });
                  _saveData();
                  Navigator.pop(ctx);
                },
                child: const Text('حفظ'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPartnersAndReviewsTab() {
    final profitPool = math.max(0.0, _netProfit);
    final revTargetCtrl = TextEditingController();
    final revCommentCtrl = TextEditingController();
    String revType = 'منتج';
    int revStars = 5;

    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('الشركاء والأدوار والنسب', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                  ElevatedButton.icon(
                    onPressed: () => _openPartnerDialog(),
                    icon: const Icon(Icons.person_add, size: 16),
                    label: const Text('إضافة', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ..._partners.map((pt) {
                final shareAmt = profitPool * (pt.sharePercent / 100.0);
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(border: Border.all(color: Colors.black12), borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${pt.name} (${pt.role})', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12.5)),
                            Text(
                              'نسبة: ${pt.sharePercent.toStringAsFixed(0)}% • ربح: ${_fmt(shareAmt)} • عمولات: ${_fmt(pt.earnedCommission)}',
                              style: const TextStyle(fontSize: 11, color: Color(0xFF059669), fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => _openPartnerDialog(existing: pt),
                        icon: const Icon(Icons.edit, size: 18),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('تقييمات الزبائن والمنتجات (إثبات اجتماعي)', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13.5)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: revType,
                decoration: _inputDeco('نوع التقييم'),
                items: const [
                  DropdownMenuItem(value: 'منتج', child: Text('تقييم منتج', style: TextStyle(fontSize: 12))),
                  DropdownMenuItem(value: 'زبون', child: Text('تقييم زبون', style: TextStyle(fontSize: 12))),
                ],
                onChanged: (v) {
                  if (v != null) revType = v;
                },
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: TextField(controller: revTargetCtrl, decoration: _inputDeco('اسم المنتج أو الزبون'))),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 85,
                    child: DropdownButtonFormField<int>(
                      value: revStars,
                      decoration: _inputDeco('النجوم'),
                      items: [5, 4, 3, 2, 1].map((n) => DropdownMenuItem(value: n, child: Text('$n ★', style: const TextStyle(fontSize: 12)))).toList(),
                      onChanged: (v) {
                        if (v != null) revStars = v;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(controller: revCommentCtrl, decoration: _inputDeco('نص التقييم أو الملاحظة')),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  if (revTargetCtrl.text.trim().isEmpty) return;
                  setState(() {
                    _reviews.insert(
                      0,
                      ReviewRecord(
                        id: 'rev-${DateTime.now().millisecondsSinceEpoch}',
                        subjectType: revType,
                        targetName: revTargetCtrl.text.trim(),
                        rating: revStars,
                        comment: revCommentCtrl.text.trim(),
                      ),
                    );
                  });
                  _saveData();
                  revTargetCtrl.clear();
                  revCommentCtrl.clear();
                },
                child: const Text('حفظ التقييم', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
              const SizedBox(height: 8),
              ..._reviews.map(
                (r) => Text(
                  '• [${r.subjectType}] ${r.targetName} (${r.rating}★): ${r.comment}',
                  style: const TextStyle(fontSize: 11.5),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWhatsappAndCouponsTab() {
    final prod = _products.firstWhere((p) => p.id == _promoProductId, orElse: () => _products.first);
    final promoMsg =
        '🔥 متوفر الآن: ${prod.name}\nالسعر: ${_fmt(prod.sellPrice)}\nتوصيل سريع إلى 58 ولاية والدفع عند الاستلام.\nاطلب الآن وأرسل موديل هاتفك والولاية!';

    final codeCtrl = TextEditingController();
    final discCtrl = TextEditingController(text: '150');

    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('مولّد رسائل الواتساب الجاهزة', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _products.any((p) => p.id == _promoProductId) ? _promoProductId : (_products.isNotEmpty ? _products.first.id : null),
                decoration: _inputDeco('اختر المنتج'),
                items: _products.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name, style: const TextStyle(fontSize: 12)))).toList(),
                onChanged: (v) => setState(() => _promoProductId = v),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(border: Border.all(color: Colors.black12), borderRadius: BorderRadius.circular(8)),
                child: Text(promoMsg, style: const TextStyle(fontSize: 12, height: 1.5)),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () => _copyText(promoMsg, 'رسالة الواتساب الترويجية'),
                icon: const Icon(Icons.copy, size: 16),
                label: const Text('نسخ الرسالة', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('كوبونات الخصم لإعادة الشراء', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: TextField(controller: codeCtrl, decoration: _inputDeco('رمز الكوبون (مثال: DZ500)'))),
                  const SizedBox(width: 8),
                  Expanded(child: TextField(controller: discCtrl, keyboardType: TextInputType.number, decoration: _inputDeco('قيمة الخصم (دج)'))),
                  IconButton(
                    onPressed: () {
                      final c = codeCtrl.text.trim().toUpperCase();
                      final d = double.tryParse(discCtrl.text.trim()) ?? 0;
                      if (c.isEmpty || d <= 0) return;
                      setState(() => _coupons.add(CouponItem(code: c, discountValue: d, note: 'إعادة شراء')));
                      _saveData();
                      codeCtrl.clear();
                    },
                    icon: const Icon(Icons.add_circle, color: Color(0xFF059669)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ..._coupons.map((c) => Text('• ${c.code}: خصم ${_fmt(c.discountValue)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMarketingBookTab() {
    final page = kMarketingPages[_marketingPageIdx];
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('صفحة ${page.pageNumber} من ${kMarketingPages.length} • ${page.thinker}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: Color(0xFF059669))),
              const SizedBox(height: 4),
              Text(page.title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15.5)),
              const Divider(),
              Text('الفكرة: ${page.coreIdea}', style: const TextStyle(fontSize: 12, height: 1.5)),
              const SizedBox(height: 6),
              Text('الحيلة: ${page.trick}', style: const TextStyle(fontSize: 12, height: 1.5)),
              const SizedBox(height: 6),
              Text('إكسسوارات الهواتف: ${page.phoneAccessoriesCase}', style: const TextStyle(fontSize: 12, height: 1.5)),
              const SizedBox(height: 6),
              Text('القنوات: ${page.channelsFocus}', style: const TextStyle(fontSize: 12, height: 1.5)),
              const SizedBox(height: 6),
              Text(page.pitfallAndFix, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFFD97706))),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _marketingPageIdx > 0 ? () => setState(() => _marketingPageIdx--) : null,
                      child: const Text('السابق'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _marketingPageIdx < kMarketingPages.length - 1 ? () => setState(() => _marketingPageIdx++) : null,
                      child: const Text('التالي'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: widget.isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: widget.isDarkMode ? Colors.white12 : const Color(0xFFE2E8F0)),
      ),
      child: child,
    );
  }

  InputDecoration _inputDeco(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700),
      isDense: true,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
