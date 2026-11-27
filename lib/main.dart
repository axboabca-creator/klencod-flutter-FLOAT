import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AccFlowDzApp());
}

class AccFlowDzApp extends StatelessWidget {
  const AccFlowDzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AccFlow DZ - AZEDDIN BOABCA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F172A),
          primary: const Color(0xFF0F172A),
          secondary: const Color(0xFF059669),
          surface: const Color(0xFFF8FAFC),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        fontFamily: 'Roboto',
      ),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: MainDashboardShell(),
      ),
    );
  }
}

class ProductItem {
  final String id;
  String name;
  String category;
  double wholesalePrice;
  double sellPrice;
  int quantity;
  int minAlert;
  int soldCount;

  ProductItem({
    required this.id,
    required this.name,
    required this.category,
    required this.wholesalePrice,
    required this.sellPrice,
    required this.quantity,
    required this.minAlert,
    required this.soldCount,
  });

  bool get isLowStock => quantity <= minAlert;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'wholesalePrice': wholesalePrice,
        'sellPrice': sellPrice,
        'quantity': quantity,
        'minAlert': minAlert,
        'soldCount': soldCount,
      };

  factory ProductItem.fromJson(Map<String, dynamic> j) => ProductItem(
        id: j['id'] ?? '',
        name: j['name'] ?? '',
        category: j['category'] ?? 'أخرى',
        wholesalePrice: (j['wholesalePrice'] ?? 0).toDouble(),
        sellPrice: (j['sellPrice'] ?? 0).toDouble(),
        quantity: (j['quantity'] ?? 0).toInt(),
        minAlert: (j['minAlert'] ?? 5).toInt(),
        soldCount: (j['soldCount'] ?? 0).toInt(),
      );
}

class WilayaRate {
  final int code;
  final String name;
  double stopDesk;
  double domicile;
  double returnRate;

  WilayaRate({
    required this.code,
    required this.name,
    required this.stopDesk,
    required this.domicile,
    required this.returnRate,
  });

  Map<String, dynamic> toJson() => {
        'code': code,
        'name': name,
        'stopDesk': stopDesk,
        'domicile': domicile,
        'returnRate': returnRate,
      };

  factory WilayaRate.fromJson(Map<String, dynamic> j) => WilayaRate(
        code: (j['code'] ?? 0).toInt(),
        name: j['name'] ?? '',
        stopDesk: (j['stopDesk'] ?? 450).toDouble(),
        domicile: (j['domicile'] ?? 700).toDouble(),
        returnRate: (j['returnRate'] ?? 5).toDouble(),
      );
}

class PartnerItem {
  final String id;
  final String name;
  final double sharePercent;
  double earnedCommission;

  PartnerItem({
    required this.id,
    required this.name,
    required this.sharePercent,
    this.earnedCommission = 0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'sharePercent': sharePercent,
        'earnedCommission': earnedCommission,
      };

  factory PartnerItem.fromJson(Map<String, dynamic> j) => PartnerItem(
        id: j['id'] ?? '',
        name: j['name'] ?? '',
        sharePercent: (j['sharePercent'] ?? 33.3).toDouble(),
        earnedCommission: (j['earnedCommission'] ?? 0).toDouble(),
      );
}

class OrderRecord {
  final String id;
  final String productName;
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

const List<MarketingPage> kPagesPart1 = [
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
];
const List<MarketingPage> kPagesPart2 = [
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

const List<MarketingPage> kMarketingPages = [...kPagesPart1, ...kPagesPart2];
class MainDashboardShell extends StatefulWidget {
  const MainDashboardShell({super.key});

  @override
  State<MainDashboardShell> createState() => _MainDashboardShellState();
}

class _MainDashboardShellState extends State<MainDashboardShell> {
  int _currentIndex = 0;

  List<String> _categories = [
    'شواحن',
    'كابلات',
    'سماعات',
    'أغطية',
    'واقي شاشة',
    'باور بانك',
    'أخرى',
  ];
  String _selectedCategoryFilter = 'الكل';

  List<ProductItem> _products = [];
  List<WilayaRate> _wilayas = [];
  List<PartnerItem> _partners = [];
  List<OrderRecord> _orders = [];
  List<String> _activityLog = [];
  String? _bannerMessage;
  bool _bannerIsError = false;

  final _prodNameCtrl = TextEditingController();
  final _newCatCtrl = TextEditingController();
  final _wholesaleCtrl = TextEditingController();
  final _sellCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();
  final _minAlertCtrl = TextEditingController(text: '5');
  String _formCategory = 'شواحن';

  String? _calcProductId;
  int _calcQty = 1;
  int _calcWilayaCode = 16;
  String _calcDeliveryType = 'stopdesk';
  String? _calcPartnerId;
  double _calcCommission = 150;

  String _wilayaSearch = '';
  int _marketingPageIdx = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _prodNameCtrl.dispose();
    _newCatCtrl.dispose();
    _wholesaleCtrl.dispose();
    _sellCtrl.dispose();
    _qtyCtrl.dispose();
    _minAlertCtrl.dispose();
    super.dispose();
  }

  void _showBanner(String msg, {bool isError = false}) {
    setState(() {
      _bannerMessage = msg;
      _bannerIsError = isError;
    });
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
        returnRate: isSouth ? 8.0 : 5.0,
      );
    });
  }

  void _seedDemoData() {
    _categories = [
      'شواحن',
      'كابلات',
      'سماعات',
      'أغطية',
      'واقي شاشة',
      'باور بانك',
      'أخرى',
    ];
    _formCategory = 'شواحن';
    _selectedCategoryFilter = 'الكل';

    _products = [
      ProductItem(
        id: 'p1',
        name: 'شاحن سريع 33W PD',
        category: 'شواحن',
        wholesalePrice: 1100,
        sellPrice: 2100,
        quantity: 18,
        minAlert: 5,
        soldCount: 24,
      ),
      ProductItem(
        id: 'p2',
        name: 'كابل Type-C مقوى نايلون',
        category: 'كابلات',
        wholesalePrice: 450,
        sellPrice: 950,
        quantity: 4,
        minAlert: 5,
        soldCount: 31,
      ),
      ProductItem(
        id: 'p3',
        name: 'سماعات لاسلكية ANC',
        category: 'سماعات',
        wholesalePrice: 1800,
        sellPrice: 3200,
        quantity: 10,
        minAlert: 4,
        soldCount: 12,
      ),
      ProductItem(
        id: 'p4',
        name: 'باور بانك 10000mAh',
        category: 'باور بانك',
        wholesalePrice: 2400,
        sellPrice: 3900,
        quantity: 7,
        minAlert: 3,
        soldCount: 9,
      ),
      ProductItem(
        id: 'p5',
        name: 'غطاء سيليكون قديم',
        category: 'أغطية',
        wholesalePrice: 300,
        sellPrice: 650,
        quantity: 2,
        minAlert: 4,
        soldCount: 2,
      ),
      ProductItem(
        id: 'p6',
        name: 'واقي شاشة زجاج حراري',
        category: 'واقي شاشة',
        wholesalePrice: 250,
        sellPrice: 600,
        quantity: 15,
        minAlert: 6,
        soldCount: 17,
      ),
    ];

    _wilayas = _defaultWilayas();

    _partners = [
    PartnerItem(id: 'pt1', name: 'عشير صلاح الدين', sharePercent: 25, earnedCommission: 600),
     PartnerItem(id: 'pt2', name: 'بوعبسة عزالدين', sharePercent: 25, earnedCommission: 600),
      PartnerItem(id: 'pt3', name: 'يوسف بالعربي', sharePercent: 25, earnedCommission: 600),
      PartnerItem(id: 'Pt4',name: عزيرية قويدر', sharePercent: 25, earnedCommission: 600),
    ];

    _orders = [
      OrderRecord(
        id: 'ord-1',
        productName: 'شاحن سريع 33W PD',
        wilayaName: 'الجزائر',
        deliveryType: 'مكتب (Stop Desk)',
        qty: 2,
        shippingCost: 450,
        commission: 150,
        netProfit: 1850,
        finalPrice: 4650,
        partnerName: 'AZEDDIN BOABCA',
        dateStr: 'اليوم',
      ),
      OrderRecord(
        id: 'ord-2',
        productName: 'كابل Type-C مقوى نايلون',
        wilayaName: 'وهران',
        deliveryType: 'منزل (Domicile)',
        qty: 3,
        shippingCost: 700,
        commission: 150,
        netProfit: 1350,
        finalPrice: 3550,
        partnerName: 'شريك 2',
        dateStr: 'اليوم',
      ),
    ];

    _activityLog = [
      'تم تهيئة البيانات التجريبية لنظام AccFlow DZ - إعداد AZEDDIN BOABCA',
      'تسجيل طلبية: شاحن سريع 33W PD (2 قطعة) إلى الجزائر',
      'تسجيل طلبية: كابل Type-C مقوى نايلون (3 قطعة) إلى وهران',
    ];

    _calcProductId = _products.first.id;
    _calcPartnerId = _partners.first.id;
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('accflow_dz_flutter_v1');
    if (raw == null || raw.isEmpty) {
      setState(() => _seedDemoData());
      await _saveData();
      return;
    }

    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      setState(() {
        final cats = (map['categories'] as List<dynamic>?)?.map((e) => e.toString()).toList();
        _categories = (cats != null && cats.isNotEmpty)
            ? cats
            : ['شواحن', 'كابلات', 'سماعات', 'أغطية', 'واقي شاشة', 'باور بانك', 'أخرى'];
        if (!_categories.contains(_formCategory)) {
          _formCategory = _categories.first;
        }

        _products = (map['products'] as List<dynamic>?)
                ?.map((e) => ProductItem.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];

        final wils = (map['wilayas'] as List<dynamic>?)
                ?.map((e) => WilayaRate.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];
        _wilayas = wils.length == 58 ? wils : _defaultWilayas();

        final parts = (map['partners'] as List<dynamic>?)
                ?.map((e) => PartnerItem.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];
        _partners = parts.isNotEmpty
            ? parts
            : [
                PartnerItem(id: 'pt1', name: 'AZEDDIN BOABCA', sharePercent: 40),
                PartnerItem(id: 'pt2', name: 'شريك 2', sharePercent: 30),
                PartnerItem(id: 'pt3', name: 'شريك 3', sharePercent: 30),
              ];

        _orders = (map['orders'] as List<dynamic>?)
                ?.map((e) => OrderRecord.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];

        _activityLog = (map['activityLog'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];

        if (_products.isNotEmpty && !_products.any((p) => p.id == _calcProductId)) {
          _calcProductId = _products.first.id;
        }
        if (_partners.isNotEmpty && !_partners.any((p) => p.id == _calcPartnerId)) {
          _calcPartnerId = _partners.first.id;
        }
      });
    } catch (_) {
      setState(() => _seedDemoData());
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final payload = {
      'categories': _categories,
      'products': _products.map((e) => e.toJson()).toList(),
      'wilayas': _wilayas.map((e) => e.toJson()).toList(),
      'partners': _partners.map((e) => e.toJson()).toList(),
      'orders': _orders.map((e) => e.toJson()).toList(),
      'activityLog': _activityLog,
    };
    await prefs.setString('accflow_dz_flutter_v1', jsonEncode(payload));
  }

  void _logAction(String entry) {
    final now = TimeOfDay.now();
    final stamp = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    _activityLog.insert(0, '[$stamp] $entry');
    if (_activityLog.length > 80) {
      _activityLog = _activityLog.sublist(0, 80);
    }
  }

  double get _totalSales => _orders.fold(0, (sum, o) => sum + o.finalPrice);
  double get _netProfit => _orders.fold(0, (sum, o) => sum + o.netProfit);
  double get _wholesaleCapital =>
      _products.fold(0, (sum, p) => sum + (p.wholesalePrice * p.quantity));
  int get _lowStockCount => _products.where((p) => p.isLowStock).length;

  List<ProductItem> get _mostRequested {
    final copy = [..._products];
    copy.sort((a, b) => b.soldCount.compareTo(a.soldCount));
    return copy.take(5).toList();
  }

  List<ProductItem> get _leastRequested {
    final copy = [..._products];
    copy.sort((a, b) => a.soldCount.compareTo(b.soldCount));
    return copy.take(5).toList();
  }

  void _addCustomCategory() {
    final raw = _newCatCtrl.text.trim();
    if (raw.isEmpty) {
      _showBanner('اكتب اسم الفئة الجديدة أولاً.', isError: true);
      return;
    }
    if (_categories.contains(raw)) {
      _showBanner('هذه الفئة موجودة مسبقاً.', isError: true);
      return;
    }
    setState(() {
      _categories.add(raw);
      _formCategory = raw;
      _newCatCtrl.clear();
      _logAction('إضافة فئة جديدة: $raw');
    });
    _saveData();
    _showBanner('تمت إضافة الفئة "$raw" بنجاح.');
  }

  void _addProduct() {
    final name = _prodNameCtrl.text.trim();
    final wholesale = double.tryParse(_wholesaleCtrl.text.trim()) ?? -1;
    final sell = double.tryParse(_sellCtrl.text.trim()) ?? -1;
    final qty = int.tryParse(_qtyCtrl.text.trim()) ?? -1;
    final minAlert = int.tryParse(_minAlertCtrl.text.trim()) ?? 5;

    if (name.isEmpty || wholesale < 0 || sell < 0 || qty < 0 || minAlert < 0) {
      _showBanner('يرجى إدخال بيانات صحيحة لجميع حقول المنتج.', isError: true);
      return;
    }

    final item = ProductItem(
      id: 'p-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      category: _formCategory,
      wholesalePrice: wholesale,
      sellPrice: sell,
      quantity: qty,
      minAlert: minAlert,
      soldCount: 0,
    );

    setState(() {
      _products.add(item);
      _calcProductId ??= item.id;
      _prodNameCtrl.clear();
      _wholesaleCtrl.clear();
      _sellCtrl.clear();
      _qtyCtrl.clear();
      _minAlertCtrl.text = '5';
      _logAction('إضافة منتج: ${item.name} (${item.category}) - كمية: ${item.quantity}');
    });
    _saveData();
    _showBanner('تمت إضافة المنتج "${item.name}" إلى المخزون.');
  }

  void _adjustProductQty(ProductItem item, int delta) {
    final next = item.quantity + delta;
    if (next < 0) return;
    setState(() {
      item.quantity = next;
      _logAction('تعديل كمية ${item.name} إلى ${item.quantity}');
    });
    _saveData();
  }

  void _deleteProduct(ProductItem item) {
    setState(() {
      _products.removeWhere((p) => p.id == item.id);
      if (_calcProductId == item.id) {
        _calcProductId = _products.isNotEmpty ? _products.first.id : null;
      }
      _logAction('حذف منتج من المخزون: ${item.name} (الكمية كانت ${item.quantity})');
    });
    _saveData();
    _showBanner('تم حذف المنتج "${item.name}" من المخزون.');
  }

  ProductItem? get _selectedProduct => _products.isEmpty
      ? null
      : _products.firstWhere((p) => p.id == _calcProductId, orElse: () => _products.first);

  WilayaRate get _selectedWilaya =>
      _wilayas.firstWhere((w) => w.code == _calcWilayaCode, orElse: () => _wilayas.first);

  PartnerItem? get _selectedPartner => _partners.isEmpty
      ? null
      : _partners.firstWhere((p) => p.id == _calcPartnerId, orElse: () => _partners.first);

  double get _calcShippingCost =>
      _calcDeliveryType == 'domicile' ? _selectedWilaya.domicile : _selectedWilaya.stopDesk;

  double get _calcSubtotal => (_selectedProduct?.sellPrice ?? 0) * _calcQty;
  double get _calcWholesaleTotal => (_selectedProduct?.wholesalePrice ?? 0) * _calcQty;
  double get _calcNetProfit => _calcSubtotal - _calcWholesaleTotal - _calcCommission;
  double get _calcFinalCustomerPrice => _calcSubtotal + _calcShippingCost;

  void _confirmOrder() {
    final prod = _selectedProduct;
    if (prod == null) {
      _showBanner('لا يوجد منتج متاح لتسجيل طلبية.', isError: true);
      return;
    }
    if (_calcQty <= 0) {
      _showBanner('الكمية المطلوبة يجب أن تكون 1 على الأقل.', isError: true);
      return;
    }
    if (prod.quantity < _calcQty) {
      _showBanner('الكمية المتوفرة (${prod.quantity}) غير كافية للطلبية ($_calcQty).', isError: true);
      return;
    }

    final partner = _selectedPartner;
    final record = OrderRecord(
      id: 'ord-${DateTime.now().millisecondsSinceEpoch}',
      productName: prod.name,
      wilayaName: _selectedWilaya.name,
      deliveryType: _calcDeliveryType == 'domicile' ? 'منزل (Domicile)' : 'مكتب (Stop Desk)',
      qty: _calcQty,
      shippingCost: _calcShippingCost,
      commission: _calcCommission,
      netProfit: _calcNetProfit,
      finalPrice: _calcFinalCustomerPrice,
      partnerName: partner?.name ?? 'غير محدد',
      dateStr: 'مسجلة الآن',
    );

    setState(() {
      prod.quantity -= _calcQty;
      prod.soldCount += _calcQty;
      if (partner != null) partner.earnedCommission += _calcCommission;
      _orders.insert(0, record);
      _logAction(
        'تأكيد طلبية: ${prod.name} × $_calcQty إلى ${_selectedWilaya.name} | النهائي: ${_calcFinalCustomerPrice.toStringAsFixed(0)} دج',
      );
    });
    _saveData();
    _showBanner('تم تأكيد الطلبية وخصم $_calcQty من "${prod.name}".');
  }

  String _fmt(double v) => '${v.toStringAsFixed(0)} دج';
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0.5,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'AccFlow DZ',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFF0F172A)),
            ),
            Text(
              'إكسسوارات الهواتف • 58 ولاية • الشركاء • التسويق',
              style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'استعادة البيانات التجريبية',
            onPressed: () {
              setState(() => _seedDemoData());
              _saveData();
              _showBanner('تمت استعادة البيانات التجريبية.');
            },
            icon: const Icon(Icons.restore, color: Color(0xFF0F172A)),
          ),
          IconButton(
            tooltip: 'تصفير الكل',
            onPressed: () async {
              setState(() {
                _products.clear();
                _orders.clear();
                _activityLog.clear();
                for (final p in _partners) {
                  p.earnedCommission = 0;
                }
                _calcProductId = null;
                _logAction('تم تصفير المخزون والطلبيات والعمولات');
              });
              await _saveData();
              _showBanner('تم تصفير البيانات بنجاح.', isError: true);
            },
            icon: const Icon(Icons.delete_sweep, color: Color(0xFFDC2626)),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                _navChip(0, 'لوحة التحكم'),
                _navChip(1, 'المخزون الذكي'),
                _navChip(2, 'التسعير والطلبيات'),
                _navChip(3, '58 ولاية'),
                _navChip(4, 'الشركاء والسجل'),
                _navChip(5, 'عقليات التسويق (15 ص)'),
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
              margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _bannerIsError ? const Color(0xFFBE123C) : const Color(0xFF047857),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _bannerMessage = null),
                    child: const Text(
                      'إغلاق',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        decoration: TextDecoration.underline,
                      ),
                    ),
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
      padding: const EdgeInsets.only(left: 8),
      child: ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: active ? Colors.white : const Color(0xFF334155),
          ),
        ),
        selected: active,
        selectedColor: const Color(0xFF0F172A),
        backgroundColor: const Color(0xFFF1F5F9),
        showCheckmark: false,
        onSelected: (_) => setState(() => _currentIndex = index),
      ),
    );
  }

  Widget _buildDeveloperFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        runAlignment: WrapAlignment.center,
        spacing: 12,
        runSpacing: 4,
        children: const [
          Text(
            'المبرمج: AZEDDIN BOABCA',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
          ),
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
        return _buildOrdersTab();
      case 3:
        return _buildWilayasTab();
      case 4:
        return _buildPartnersTab();
      case 5:
        return _buildMarketingBookTab();
      default:
        return _buildDashboardTab();
    }
  }
    Widget _buildDashboardTab() {
    final top = _mostRequested;
    final low = _leastRequested;
    final maxTop = top.isEmpty ? 1 : top.map((e) => e.soldCount).reduce(math.max).clamp(1, 999999);
    final maxLow = low.isEmpty ? 1 : low.map((e) => e.soldCount).reduce(math.max).clamp(1, 999999);
    final lowItems = _products.where((p) => p.isLowStock).toList();

    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        GridView.count(
          crossAxisCount: MediaQuery.of(context).size.width > 700 ? 4 : 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.55,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _kpiCard('إجمالي المبيعات', _fmt(_totalSales), const Color(0xFF0F172A), 'الطلبيات المؤكدة'),
            _kpiCard('صافي الأرباح', _fmt(_netProfit), const Color(0xFF059669), 'بعد الجملة والعمولات'),
            _kpiCard('رأس مال المخزون', _fmt(_wholesaleCapital), const Color(0xFF2563EB), 'قيمة الجملة الحالية'),
            _kpiCard('كمية محدودة', '$_lowStockCount', const Color(0xFFDC2626), 'وصلت للحد الأدنى'),
          ],
        ),
        const SizedBox(height: 14),
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'أكثر المنتجات طلباً (حسب الوحدات المباعة)',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
              ),
              const SizedBox(height: 10),
              if (top.isEmpty)
                const Text('لا توجد بيانات مبيعات بعد.', style: TextStyle(fontSize: 12, color: Colors.grey))
              else
                ...top.map((p) => _barRow(p.name, p.soldCount, maxTop, const Color(0xFF059669))),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'أقل المنتجات طلباً (تحتاج تحريكاً أو دمجاً)',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
              ),
              const SizedBox(height: 10),
              if (low.isEmpty)
                const Text('لا توجد منتجات مسجلة.', style: TextStyle(fontSize: 12, color: Colors.grey))
              else
                ...low.map((p) => _barRow(p.name, p.soldCount, maxLow, const Color(0xFFD97706))),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: const Text(
                  'نصيحة عملية: ادمج القطع الأقل طلباً ضمن باك مع شاحن أو كابل سريع عليه طلب مرتفع، أو صفِّ غير المرغوب منها واحذفه لتفريغ رأس المال.',
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF92400E)),
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
              const Text(
                'تنبيهات الكمية المحدودة',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
              ),
              const SizedBox(height: 8),
              if (lowItems.isEmpty)
                const Text(
                  'كل المنتجات فوق الحد الأدنى للتنبيه.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF059669), fontWeight: FontWeight.w700),
                )
              else
                ...lowItems.map(
                  (p) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${p.name} (${p.category})',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFFBE123C)),
                        ),
                        Text(
                          'متبقي ${p.quantity} (الحد ${p.minAlert})',
                          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: Color(0xFFDC2626)),
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

  Widget _kpiCard(String title, String value, Color valueColor, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
          Text(value, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: valueColor)),
          Text(subtitle, style: const TextStyle(fontSize: 10.5, color: Color(0xFF94A3B8))),
        ],
      ),
    );
  }

  Widget _barRow(String label, int count, int maxCount, Color color) {
    final ratio = (count / maxCount).clamp(0.04, 1.0);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ),
              Text('$count مباع', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: color)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 8,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryTab() {
    final filtered = _selectedCategoryFilter == 'الكل'
        ? _products
        : _products.where((p) => p.category == _selectedCategoryFilter).toList();

    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('إضافة فئة جديدة مخصصة', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13.5)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _newCatCtrl,
                      decoration: _inputDeco('اكتب فئة جديدة (مثال: حوامل سيارة، ساعات ذكية...)'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _addCustomCategory,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF059669),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                    child: const Text('إضافة فئة', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
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
              const Text('إضافة منتج إكسسوار جديد', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
              const SizedBox(height: 10),
              TextField(
                controller: _prodNameCtrl,
                decoration: _inputDeco('اسم المنتج (مثال: شاحن 45W أو كابل Type-C)'),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _categories.contains(_formCategory) ? _formCategory : _categories.first,
                decoration: _inputDeco('اختر الفئة'),
                items: _categories
                    .map((c) => DropdownMenuItem<String>(value: c, child: Text(c, style: const TextStyle(fontSize: 12))))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _formCategory = val);
                },
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _wholesaleCtrl,
                      keyboardType: TextInputType.number,
                      decoration: _inputDeco('سعر الجملة (دج)'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _sellCtrl,
                      keyboardType: TextInputType.number,
                      decoration: _inputDeco('سعر البيع (دج)'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _qtyCtrl,
                      keyboardType: TextInputType.number,
                      decoration: _inputDeco('الكمية'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _minAlertCtrl,
                      keyboardType: TextInputType.number,
                      decoration: _inputDeco('حد التنبيه'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _addProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('حفظ المنتج في المخزون', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ['الكل', ..._categories].map((cat) {
              final selected = _selectedCategoryFilter == cat;
              return Padding(
                padding: const EdgeInsets.only(left: 6),
                child: ChoiceChip(
                  label: Text(
                    cat,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: selected ? Colors.white : const Color(0xFF334155),
                    ),
                  ),
                  selected: selected,
                  selectedColor: const Color(0xFF0F172A),
                  backgroundColor: Colors.white,
                  showCheckmark: false,
                  onSelected: (_) => setState(() => _selectedCategoryFilter = cat),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 10),
        if (filtered.isEmpty)
          _card(
            child: const Center(
              child: Text('لا توجد منتجات في هذه الفئة.', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ),
          )
        else
          ...filtered.map((item) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: item.isLowStock ? const Color(0xFFFCA5A5) : const Color(0xFFE2E8F0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13.5),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(item.category, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'جملة: ${_fmt(item.wholesalePrice)}  •  بيع: ${_fmt(item.sellPrice)}  •  مباع: ${item.soldCount}',
                    style: const TextStyle(fontSize: 11.5, color: Color(0xFF475569), fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.isLowStock
                            ? 'كمية محدودة: ${item.quantity} (الحد ${item.minAlert})'
                            : 'الكمية المتوفرة: ${item.quantity}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: item.isLowStock ? const Color(0xFFDC2626) : const Color(0xFF059669),
                        ),
                      ),
                      Row(
                        children: [
                          _miniBtn('-', () => _adjustProductQty(item, -1)),
                          const SizedBox(width: 6),
                          _miniBtn('+', () => _adjustProductQty(item, 1)),
                          const SizedBox(width: 8),
                          IconButton(
                            tooltip: 'حذف المنتج',
                            visualDensity: VisualDensity.compact,
                            onPressed: () => _deleteProduct(item),
                            icon: const Icon(Icons.delete_outline, color: Color(0xFFDC2626), size: 20),
                          ),
                        ],
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

  Widget _miniBtn(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 28,
        height: 28,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFCBD5E1)),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
      ),
    );
  }
    Widget _buildOrdersTab() {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'حاسبة التسعير وتسجيل طلبية جديدة',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _products.any((p) => p.id == _calcProductId)
                    ? _calcProductId
                    : (_products.isNotEmpty ? _products.first.id : null),
                decoration: _inputDeco('اختر المنتج'),
                items: _products
                    .map(
                      (p) => DropdownMenuItem<String>(
                        value: p.id,
                        child: Text('${p.name} (متوفر: ${p.quantity})', style: const TextStyle(fontSize: 12)),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _calcProductId = v),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: _calcQty.toString(),
                      keyboardType: TextInputType.number,
                      decoration: _inputDeco('الكمية المطلوبة'),
                      onChanged: (v) => setState(() => _calcQty = int.tryParse(v) ?? 1),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: _calcWilayaCode,
                      decoration: _inputDeco('الولاية (58)'),
                      items: _wilayas
                          .map(
                            (w) => DropdownMenuItem<int>(
                              value: w.code,
                              child: Text('${w.code} - ${w.name}', style: const TextStyle(fontSize: 12)),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _calcWilayaCode = v);
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
                      value: _calcDeliveryType,
                      decoration: _inputDeco('نوع التوصيل'),
                      items: const [
                        DropdownMenuItem(value: 'stopdesk', child: Text('مكتب (Stop Desk)', style: TextStyle(fontSize: 12))),
                        DropdownMenuItem(value: 'domicile', child: Text('منزل (Domicile)', style: TextStyle(fontSize: 12))),
                      ],
                      onChanged: (v) {
                        if (v != null) setState(() => _calcDeliveryType = v);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _partners.any((p) => p.id == _calcPartnerId)
                          ? _calcPartnerId
                          : (_partners.isNotEmpty ? _partners.first.id : null),
                      decoration: _inputDeco('الشريك'),
                      items: _partners
                          .map((p) => DropdownMenuItem<String>(value: p.id, child: Text(p.name, style: const TextStyle(fontSize: 12))))
                          .toList(),
                      onChanged: (v) => setState(() => _calcPartnerId = v),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: _calcCommission.toStringAsFixed(0),
                keyboardType: TextInputType.number,
                decoration: _inputDeco('قيمة العمولة للطلبية (دج)'),
                onChanged: (v) => setState(() => _calcCommission = double.tryParse(v) ?? 0),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    _summaryRow('مجموع سعر البيع للقطع:', _fmt(_calcSubtotal)),
                    _summaryRow('تكلفة الجملة الإجمالية:', _fmt(_calcWholesaleTotal)),
                    _summaryRow('مصاريف التوصيل للولاية:', _fmt(_calcShippingCost)),
                    _summaryRow('العمولة المحتسبة:', _fmt(_calcCommission)),
                    _summaryRow('صافي الربح:', _fmt(_calcNetProfit), valueColor: const Color(0xFF059669)),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('السعر النهائي للزبون:', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                        Text(
                          _fmt(_calcFinalCustomerPrice),
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF0F172A)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _confirmOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF059669),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('تأكيد الطلبية وخصم الكمية', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5)),
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
              Text(
                'سجل الطلبيات المؤكدة (${_orders.length})',
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
              ),
              const SizedBox(height: 8),
              if (_orders.isEmpty)
                const Text('لا توجد طلبيات مسجلة بعد.', style: TextStyle(fontSize: 12, color: Colors.grey))
              else
                ..._orders.map(
                  (o) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${o.productName} × ${o.qty}',
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12.5),
                            ),
                            Text(
                              _fmt(o.finalPrice),
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12.5, color: Color(0xFF059669)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${o.wilayaName} • ${o.deliveryType} • شحن: ${_fmt(o.shippingCost)} • ربح صافي: ${_fmt(o.netProfit)} • ${o.partnerName}',
                          style: const TextStyle(fontSize: 11, color: Color(0xFF475569)),
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

  Widget _summaryRow(String label, String val, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF475569))),
          Text(
            val,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: valueColor ?? const Color(0xFF0F172A)),
          ),
        ],
      ),
    );
  }

  Widget _buildWilayasTab() {
    final list = _wilayas.where((w) {
      final q = _wilayaSearch.trim();
      if (q.isEmpty) return true;
      return w.name.contains(q) || w.code.toString().contains(q);
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        TextField(
          onChanged: (v) => setState(() => _wilayaSearch = v),
          decoration: _inputDeco('ابحث عن ولاية بالاسم أو الرقم (1 إلى 58)...'),
        ),
        const SizedBox(height: 10),
        ...list.map(
          (w) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${w.code} - ${w.name}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: w.stopDesk.toStringAsFixed(0),
                        keyboardType: TextInputType.number,
                        decoration: _inputDeco('مكتب (دج)'),
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
                        decoration: _inputDeco('منزل (دج)'),
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
                          w.returnRate = double.tryParse(v) ?? w.returnRate;
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

  Widget _buildPartnersTab() {
    final profitPool = math.max(0.0, _netProfit);

    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'توزيع الأرباح والعمولات بين الشركاء',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
              ),
              const SizedBox(height: 10),
              ..._partners.map((pt) {
                final shareAmt = profitPool * (pt.sharePercent / 100.0);
                final totalDue = shareAmt + pt.earnedCommission;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(pt.name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                          Text(
                            'نسبة: ${pt.sharePercent.toStringAsFixed(0)}%',
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: Color(0xFF2563EB)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'نصيب الربح: ${_fmt(shareAmt)}  •  عمولات: ${_fmt(pt.earnedCommission)}  •  الإجمالي: ${_fmt(totalDue)}',
                        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF059669)),
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
              const Text('سجل النشاط والعمليات', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
              const SizedBox(height: 8),
              if (_activityLog.isEmpty)
                const Text('لا توجد حركات مسجلة.', style: TextStyle(fontSize: 12, color: Colors.grey))
              else
                ..._activityLog.map(
                  (log) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text('• $log', style: const TextStyle(fontSize: 11.5, color: Color(0xFF334155))),
                  ),
                ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'صفحة ${page.pageNumber} من ${kMarketingPages.length}',
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: Color(0xFF059669)),
                  ),
                  Text(
                    page.thinker,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11.5, color: Color(0xFF475569)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                page.title,
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF0F172A)),
              ),
              const Divider(height: 18),
              _bookBlock('الزبدة والفكرة الجوهرية:', page.coreIdea),
              _bookBlock('الحيلة التسويقية:', page.trick),
              _bookBlock('إسقاط عملي على إكسسوارات الهواتف:', page.phoneAccessoriesCase),
              _bookBlock('القنوات الأنسب:', page.channelsFocus),
              _bookBlock('ثغرة شائعة وحلها المباشر:', page.pitfallAndFix, highlight: true),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _marketingPageIdx > 0 ? () => setState(() => _marketingPageIdx--) : null,
                      child: const Text('الصفحة السابقة', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _marketingPageIdx < kMarketingPages.length - 1
                          ? () => setState(() => _marketingPageIdx++)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F172A),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('الصفحة التالية', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
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

  Widget _bookBlock(String label, String content, {bool highlight = false}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: highlight ? const Color(0xFFFFFBEB) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: highlight ? const Color(0xFFFDE68A) : const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
          const SizedBox(height: 3),
          Text(content, style: const TextStyle(fontSize: 12, height: 1.55, color: Color(0xFF334155))),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: child,
    );
  }

  InputDecoration _inputDeco(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700),
      isDense: true,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}