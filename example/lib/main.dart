import 'package:flutter/material.dart';
import 'package:tiktok_app_events/tiktok_app_events.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _tiktokAppEvents = TiktokAppEvents();
  String _status = '未初始化';
  bool _isInitialized = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('TikTok App Events Demo'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 状态显示
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text('状态: $_status',
                          style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      Icon(
                        _isInitialized ? Icons.check_circle : Icons.error,
                        color: _isInitialized ? Colors.green : Colors.red,
                        size: 32,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // SDK 初始化
              _buildSection(
                title: 'SDK 初始化',
                children: [
                  ElevatedButton(
                    onPressed: _initSDK,
                    child: const Text('初始化 SDK'),
                  ),
                ],
              ),

              // 用户身份
              _buildSection(
                title: '用户身份',
                children: [
                  ElevatedButton(
                    onPressed: _isInitialized ? _setUserIdentity : null,
                    child: const Text('设置用户身份'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _isInitialized ? _logout : null,
                    child: const Text('登出'),
                  ),
                ],
              ),

              // 电商事件
              _buildSection(
                title: '电商事件',
                children: [
                  _buildEventButton('查看内容', _logViewContent),
                  _buildEventButton('添加到购物车', _logAddToCart),
                  _buildEventButton('添加到心愿单', _logAddToWishlist),
                  _buildEventButton('开始结账', _logInitiateCheckout),
                  _buildEventButton('添加支付信息', _logAddPaymentInfo),
                  _buildEventButton('完成支付', _logCompletePayment),
                  _buildEventButton('下单', _logPlaceAnOrder),
                  _buildEventButton('购买', _logPurchase),
                ],
              ),

              // 订阅事件
              _buildSection(
                title: '订阅事件',
                children: [
                  _buildEventButton('开始免费试用', _logStartFreeTrial),
                  _buildEventButton('订阅', _logSubscription),
                ],
              ),

              // 用户行为事件
              _buildSection(
                title: '用户行为事件',
                children: [
                  _buildEventButton('完成注册', _logCompleteRegistration),
                  _buildEventButton('登录', _logLogin),
                  _buildEventButton('搜索', _logSearch),
                  _buildEventButton('联系', _logContact),
                  _buildEventButton('提交表单', _logSubmitForm),
                  _buildEventButton('下载', _logDownload),
                  _buildEventButton('点击按钮', _logClickButton),
                ],
              ),

              // 游戏事件
              _buildSection(
                title: '游戏事件',
                children: [
                  _buildEventButton('达成等级', _logAchieveLevel),
                  _buildEventButton('创建群组', _logCreateGroup),
                  _buildEventButton('创建角色', _logCreateRole),
                  _buildEventButton('消费积分', _logSpendCredits),
                  _buildEventButton('解锁成就', _logUnlockAchievement),
                ],
              ),

              // 其他事件
              _buildSection(
                title: '其他事件',
                children: [
                  _buildEventButton('生成线索', _logGenerateLead),
                  _buildEventButton('评分', _logRate),
                  _buildEventButton('自定义事件', _logCustomEvent),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: children,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventButton(String label, VoidCallback? onPressed) {
    return ElevatedButton(
      onPressed: _isInitialized ? onPressed : null,
      child: Text(label),
    );
  }

  void _updateStatus(String status) {
    setState(() {
      _status = status;
    });
  }

  // SDK 初始化
  Future<void> _initSDK() async {
    _updateStatus('初始化中...');
    try {
      final result = await _tiktokAppEvents.initSDK(
        TikTokConfig(
          appId: 'YOUR_APP_ID', // 替换为你的 App ID
          tiktokAppId: 'YOUR_TIKTOK_APP_ID', // 替换为你的 TikTok App ID
          accessToken: 'YOUR_ACCESS_TOKEN', // 替换为你的 Access Token
          isDebug: true,
        ),
      );
      setState(() {
        _isInitialized = result ?? false;
        _status = _isInitialized ? 'SDK 初始化成功' : 'SDK 初始化失败';
      });
    } catch (e) {
      _updateStatus('初始化错误: $e');
    }
  }

  // 用户身份
  Future<void> _setUserIdentity() async {
    try {
      await _tiktokAppEvents.setUserIdentity(
        externalId: 'user_12345',
        externalUserName: 'test_user',
        email: 'test@example.com',
        phoneNumber: '+8613800138000',
      );
      _updateStatus('用户身份设置成功');
    } catch (e) {
      _updateStatus('设置用户身份错误: $e');
    }
  }

  Future<void> _logout() async {
    try {
      await _tiktokAppEvents.logout();
      _updateStatus('登出成功');
    } catch (e) {
      _updateStatus('登出错误: $e');
    }
  }

  // 电商事件
  Future<void> _logViewContent() async {
    try {
      await _tiktokAppEvents.logViewContent(
        TikTokViewContentEvent(
          contentId: 'product_001',
          contentType: 'product',
          contentName: 'iPhone 15 Pro',
          contentCategory: 'Electronics',
          price: 7999.0,
          currency: 'CNY',
          value: 7999.0,
        ),
      );
      _updateStatus('ViewContent 事件已发送');
    } catch (e) {
      _updateStatus('错误: $e');
    }
  }

  Future<void> _logAddToCart() async {
    try {
      await _tiktokAppEvents.logAddToCart(
        TikTokAddToCartEvent(
          contentId: 'product_001',
          contentType: 'product',
          contentName: 'iPhone 15 Pro',
          price: 7999.0,
          quantity: 1,
          currency: 'CNY',
          value: 7999.0,
        ),
      );
      _updateStatus('AddToCart 事件已发送');
    } catch (e) {
      _updateStatus('错误: $e');
    }
  }

  Future<void> _logAddToWishlist() async {
    try {
      await _tiktokAppEvents.logAddToWishlist(
        contentId: 'product_002',
        contentType: 'product',
        contentName: 'AirPods Pro',
        price: 1999.0,
        currency: 'CNY',
      );
      _updateStatus('AddToWishlist 事件已发送');
    } catch (e) {
      _updateStatus('错误: $e');
    }
  }

  Future<void> _logInitiateCheckout() async {
    try {
      await _tiktokAppEvents.logInitiateCheckout(
        TikTokInitiateCheckoutEvent(
          contents: [
            TikTokContentItem(
              contentId: 'product_001',
              contentType: 'product',
              price: 7999.0,
              quantity: 1,
            ),
          ],
          currency: 'CNY',
          value: 7999.0,
        ),
      );
      _updateStatus('InitiateCheckout 事件已发送');
    } catch (e) {
      _updateStatus('错误: $e');
    }
  }

  Future<void> _logAddPaymentInfo() async {
    try {
      await _tiktokAppEvents.logAddPaymentInfo(
        currency: 'CNY',
        value: 7999.0,
      );
      _updateStatus('AddPaymentInfo 事件已发送');
    } catch (e) {
      _updateStatus('错误: $e');
    }
  }

  Future<void> _logCompletePayment() async {
    try {
      await _tiktokAppEvents.logCompletePayment(
        currency: 'CNY',
        value: 7999.0,
        orderId: 'ORDER_001',
      );
      _updateStatus('CompletePayment 事件已发送');
    } catch (e) {
      _updateStatus('错误: $e');
    }
  }

  Future<void> _logPlaceAnOrder() async {
    try {
      await _tiktokAppEvents.logPlaceAnOrder(
        currency: 'CNY',
        value: 7999.0,
        orderId: 'ORDER_001',
        contents: [
          TikTokContentItem(
            contentId: 'product_001',
            contentType: 'product',
            price: 7999.0,
            quantity: 1,
          ),
        ],
      );
      _updateStatus('PlaceAnOrder 事件已发送');
    } catch (e) {
      _updateStatus('错误: $e');
    }
  }

  Future<void> _logPurchase() async {
    try {
      await _tiktokAppEvents.logPurchase(
        TikTokPurchaseEvent(
          contents: [
            TikTokContentItem(
              contentId: 'product_001',
              contentType: 'product',
              contentName: 'iPhone 15 Pro',
              price: 7999.0,
              quantity: 1,
            ),
          ],
          currency: 'CNY',
          value: 7999.0,
          orderId: 'ORDER_001',
        ),
      );
      _updateStatus('Purchase 事件已发送');
    } catch (e) {
      _updateStatus('错误: $e');
    }
  }

  // 订阅事件
  Future<void> _logStartFreeTrial() async {
    try {
      await _tiktokAppEvents.logStartFreeTrial();
      _updateStatus('StartFreeTrial 事件已发送');
    } catch (e) {
      _updateStatus('错误: $e');
    }
  }

  Future<void> _logSubscription() async {
    try {
      await _tiktokAppEvents.logSubscription(
        contentId: 'subscription_monthly',
        contentType: 'subscription',
        value: 68.0,
        currency: 'CNY',
      );
      _updateStatus('Subscription 事件已发送');
    } catch (e) {
      _updateStatus('错误: $e');
    }
  }

  // 用户行为事件
  Future<void> _logCompleteRegistration() async {
    try {
      await _tiktokAppEvents.logCompleteRegistration(
        TikTokCompleteRegistrationEvent(
          registrationMethod: 'email',
        ),
      );
      _updateStatus('CompleteRegistration 事件已发送');
    } catch (e) {
      _updateStatus('错误: $e');
    }
  }

  Future<void> _logLogin() async {
    try {
      await _tiktokAppEvents.logLogin();
      _updateStatus('Login 事件已发送');
    } catch (e) {
      _updateStatus('错误: $e');
    }
  }

  Future<void> _logSearch() async {
    try {
      await _tiktokAppEvents.logSearch(
        TikTokSearchEvent(
          query: 'iPhone',
          contentType: 'product',
          contentCategory: 'Electronics',
        ),
      );
      _updateStatus('Search 事件已发送');
    } catch (e) {
      _updateStatus('错误: $e');
    }
  }

  Future<void> _logContact() async {
    try {
      await _tiktokAppEvents.logContact();
      _updateStatus('Contact 事件已发送');
    } catch (e) {
      _updateStatus('错误: $e');
    }
  }

  Future<void> _logSubmitForm() async {
    try {
      await _tiktokAppEvents.logSubmitForm();
      _updateStatus('SubmitForm 事件已发送');
    } catch (e) {
      _updateStatus('错误: $e');
    }
  }

  Future<void> _logDownload() async {
    try {
      await _tiktokAppEvents.logDownload();
      _updateStatus('Download 事件已发送');
    } catch (e) {
      _updateStatus('错误: $e');
    }
  }

  Future<void> _logClickButton() async {
    try {
      await _tiktokAppEvents.logClickButton(
        buttonId: 'btn_buy_now',
        buttonName: 'Buy Now',
      );
      _updateStatus('ClickButton 事件已发送');
    } catch (e) {
      _updateStatus('错误: $e');
    }
  }

  // 游戏事件
  Future<void> _logAchieveLevel() async {
    try {
      await _tiktokAppEvents.logAchieveLevel(level: 10);
      _updateStatus('AchieveLevel 事件已发送');
    } catch (e) {
      _updateStatus('错误: $e');
    }
  }

  Future<void> _logCreateGroup() async {
    try {
      await _tiktokAppEvents.logCreateGroup(groupId: 'group_001');
      _updateStatus('CreateGroup 事件已发送');
    } catch (e) {
      _updateStatus('错误: $e');
    }
  }

  Future<void> _logCreateRole() async {
    try {
      await _tiktokAppEvents.logCreateRole(roleId: 'warrior');
      _updateStatus('CreateRole 事件已发送');
    } catch (e) {
      _updateStatus('错误: $e');
    }
  }

  Future<void> _logSpendCredits() async {
    try {
      await _tiktokAppEvents.logSpendCredits(
        value: 100.0,
        contentType: 'virtual_currency',
        contentId: 'gold_coins',
      );
      _updateStatus('SpendCredits 事件已发送');
    } catch (e) {
      _updateStatus('错误: $e');
    }
  }

  Future<void> _logUnlockAchievement() async {
    try {
      await _tiktokAppEvents.logUnlockAchievement(achievementId: 'first_purchase');
      _updateStatus('UnlockAchievement 事件已发送');
    } catch (e) {
      _updateStatus('错误: $e');
    }
  }

  // 其他事件
  Future<void> _logGenerateLead() async {
    try {
      await _tiktokAppEvents.logGenerateLead(
        currency: 'CNY',
        value: 500.0,
      );
      _updateStatus('GenerateLead 事件已发送');
    } catch (e) {
      _updateStatus('错误: $e');
    }
  }

  Future<void> _logRate() async {
    try {
      await _tiktokAppEvents.logRate(
        ratingValue: 4.5,
        maxRatingValue: 5.0,
        contentType: 'product',
        contentId: 'product_001',
      );
      _updateStatus('Rate 事件已发送');
    } catch (e) {
      _updateStatus('错误: $e');
    }
  }

  Future<void> _logCustomEvent() async {
    try {
      await _tiktokAppEvents.logEvent(
        'CustomEvent',
        properties: {
          'custom_param_1': 'value1',
          'custom_param_2': 123,
          'custom_param_3': true,
        },
      );
      _updateStatus('自定义事件已发送');
    } catch (e) {
      _updateStatus('错误: $e');
    }
  }
}
