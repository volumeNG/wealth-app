import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:wealth/presentation/pages/InitialPage.dart';
import 'package:wealth/presentation/pages/chatting_page.dart';
import 'package:wealth/presentation/pages/event_details.dart';
import 'package:wealth/presentation/pages/favourite_page.dart';
import 'package:wealth/presentation/pages/flipping_description.dart';
import 'package:wealth/presentation/pages/flipping_page.dart';
import 'package:wealth/presentation/pages/forgot_password.dart';
import 'package:wealth/presentation/pages/forgot_verification.dart';
import 'package:wealth/presentation/pages/my_properties_page.dart';
import 'package:wealth/presentation/pages/onboarding.dart';
import 'package:wealth/presentation/pages/payment_details.dart';
import 'package:wealth/presentation/pages/payment_made.dart';
import 'package:wealth/presentation/pages/payment_page.dart';
import 'package:wealth/presentation/pages/personal_information.dart';
import 'package:wealth/presentation/pages/profile.dart';
import 'package:wealth/presentation/pages/property_description.dart';
import 'package:wealth/presentation/pages/recently_listed.dart';
import 'package:wealth/presentation/pages/reset_password.dart';
import 'package:wealth/presentation/pages/sign_in.dart';
import 'package:wealth/presentation/pages/sign_up.dart';
import 'package:wealth/presentation/pages/specific_property_list.dart';
import 'package:wealth/presentation/pages/splash_page.dart';
import 'package:wealth/presentation/pages/support.dart';
import 'package:wealth/presentation/pages/verification_ongoing.dart';
import 'package:wealth/presentation/pages/verify_email.dart';
import 'package:wealth/features/promotions/models/PromotionModel.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      // path: '/splash',
      builder: (context, state) => SplashPage(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => FOnboardingPage(),
    ),
    GoRoute(
      path: '/signIn',
      builder: (context, state) => SignInPage(),
    ),
    // GoRoute(
    //   path: '/homepage',
    //   builder: (context, state) => HomePage(refreshHomePage: ),
    // ),
    GoRoute(
      path: '/signUp',
      builder: (context, state) => SignUpPage(),
    ),
    GoRoute(
      path: '/forgotPassword',
      builder: (context, state) => ForgotPassword(),
    ),
    GoRoute(
      path: '/verify',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: VerifyEmailSignUp(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Change the opacity of the screen using a Curve based on the the animation's
            // value
            return FadeTransition(
              opacity:
                  CurveTween(curve: Curves.easeInOutCirc).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/verificationOngoing',
      builder: (context, state) => VerificationOngoing(),
    ),
    GoRoute(
      path: '/forgotVerification/:emailAddress',
      builder: (context, state) => ForgotVerification(
        emailAddress: state.pathParameters['emailAddress']!,
      ),
    ),
    GoRoute(
      path: '/resetPassword',
      builder: (context, state) => ResetPassword(),
    ),
    GoRoute(
      path: '/recentlyListed',
      builder: (context, state) => RecentlyListedPage(),
    ),
    GoRoute(
      path: '/initial_paypage/:paymentType',
      builder: (context, state) => PaymentPage(
        paymentType: state.pathParameters['paymentType']!,
      ),
    ),
    GoRoute(
      path: '/payment/:accountType',
      builder: (context, state) => PaymentDetails(
        accountType: state.pathParameters['accountType']!,
      ),
    ),
    GoRoute(
      path: '/property/:propertyId/:type',
      builder: (context, state) => PropertyDescription(
        id: state.pathParameters['propertyId']!,
        type: state.pathParameters['type']!,
      ),
    ),
    GoRoute(
      path: '/flipping_desc/:flippingId',
      builder: (context, state) => FlippingDesc(
        id: state.pathParameters['flippingId']!,
      ),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => Profile(),
    ),
    GoRoute(
      path: '/personal_information',
      builder: (context, state) => PersonalInformation(),
    ),
    GoRoute(
      path: '/specific_property/:locationId/:name',
      builder: (context, state) => PropertyInfo(
        id: state.pathParameters['locationId']!,
        name: state.pathParameters['name']!,
      ),
    ),
    GoRoute(
      path: '/payment_made',
      builder: (context, state) => PaymentMade(),
    ),
    GoRoute(
      // path: '/',
      path: '/initial_page',
      builder: (context, state) => InitialPage(),
    ),
    GoRoute(
      path: '/flipping',
      builder: (context, state) => FlippingPage(),
    ),
    GoRoute(
      path: '/event_details/:eventId',
      builder: (context, state) => EventDetails(
        // PromotionModel promotions=
        id: state.pathParameters['eventId']!,
        promotionModel: state.extra as PromotionModel,
      ),
    ),
    GoRoute(
      path: '/support',
      builder: (context, state) => SupportPage(),
    ),
    GoRoute(
// path: '/payment',
      path: '/favourite',
      builder: (context, state) => FavouritePage(),
    ),
    GoRoute(
      path: '/chat/:chatId/:chatGroupName',
      builder: (context, state) => ChattingPage(
        id: state.pathParameters['chatId']!,
        chatGroupName: state.pathParameters['chatGroupName']!,
      ),
    ),
    GoRoute(
      path: '/my_properties',
      builder: (context, state) => PropertiesPage(),
    ),
    GoRoute(
      path: '/paystack_popup',
      builder: (context, state) =>
          PaystackPopup(paystackCheckoutUrl: state.extra as String),

      // {
      // final paystackCheckoutUrl = ;
      // return PaystackPopup(paystackCheckoutUrl: paystackCheckoutUrl);
      // },
    ),
    // GoRoute(
    //   path: '/paystack_popup/:url',
    //   builder: (context, state) {
    //     final paystackCheckoutUrl = state.query['url'] ?? '';
    //     return PaystackPopup(paystackCheckoutUrl: paystackCheckoutUrl);
    //   },
    // ),
  ],
);
