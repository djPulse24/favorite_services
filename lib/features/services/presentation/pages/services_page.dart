// lib/features/services/presentation/pages/services_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../cubit/services_cubit.dart';
import '../cubit/services_state.dart';
import '../widgets/services_list_view.dart';
import '../widgets/animated_loading_widget.dart';
import '../widgets/animated_error_widget.dart';
import '../widgets/animated_empty_favorites_widget.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({Key? key}) : super(key: key);

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _refreshController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _refreshController = AnimationController(
      duration: AppConstants.refreshDuration,
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: AppConstants.fadeDuration,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
        begin: AppConstants.opacityTransparent,
        end: AppConstants.opacityOpaque
    ).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    context.read<ServicesCubit>().loadServices();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _refreshController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _animatedRefresh() {
    _refreshController.repeat();
    context.read<ServicesCubit>().refreshServices();
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) _refreshController.stop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: _buildAnimatedAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: BlocConsumer<ServicesCubit, ServicesState>(
          listener: (context, state) {
            if (state is ServicesError) {
              context.read<ServicesCubit>().loadServices();
            }
          },
          builder: (context, state) {
            return TabBarView(
              controller: _tabController,
              children: [
                _buildAllServicesTab(context, state),
                _buildFavoritesTab(context, state),
              ],
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAnimatedAppBar() {
    return AppBar(
      title: AnimatedDefaultTextStyle(
        duration: AppConstants.mediumAnimation,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: AppConstants.fontSizeXXLarge,
          color: AppColors.textWhite,
        ),
        child: const Text(AppConstants.servicesTitle),
      ),
      elevation: 0,
      centerTitle: true,
      backgroundColor: AppColors.backgroundTransparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.purpleBlueGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Padding(
          padding: const EdgeInsets.only(top: AppConstants.borderRadius16),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundWhite,
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppConstants.borderRadius16)
              ),
              boxShadow: AppShadows.cardShadowMedium,
            ),
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(
                  text: AppConstants.allServicesTab,
                  icon: Icon(Icons.business_center),
                ),
                Tab(
                  text: AppConstants.favoritesTab,
                  icon: Icon(Icons.favorite),
                ),
              ],
              labelColor: AppColors.primaryDeepPurple,
              unselectedLabelColor: AppColors.textGrey,
              indicatorColor: AppColors.primaryDeepPurple,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.label,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAllServicesTab(BuildContext context, ServicesState state) {
    if (state is ServicesLoading) {
      return const AnimatedLoadingWidget(
        message: AppConstants.loadingServices,
      );
    }

    if (state is ServicesLoaded) {
      return Column(
        children: [
          _buildAnimatedHeader(
            icon: Icons.business_center,
            count: state.allServices.length,
            label: AppConstants.servicesAvailable,
            colors: AppColors.bluePurpleGradient,
            iconColor: Theme.of(context).primaryColor,
          ),
          Expanded(
            child: ServicesListView(
              services: state.allServices,
              onFavoriteToggle: (service) {
                context.read<ServicesCubit>().toggleServiceFavorite(service);
              },
              onRefresh: _animatedRefresh,
            ),
          ),
        ],
      );
    }

    if (state is ServicesError) {
      return AnimatedErrorWidget(
        message: state.message,
        onRetry: () => context.read<ServicesCubit>().loadServices(),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildFavoritesTab(BuildContext context, ServicesState state) {
    if (state is ServicesLoading) {
      return AnimatedLoadingWidget(
        message: AppConstants.loadingFavorites,
        color: AppColors.favoriteRed,
      );
    }

    if (state is ServicesLoaded) {
      if (state.favoriteServices.isEmpty) {
        return AnimatedEmptyFavoritesWidget(
          onExplorePressed: () => _tabController.animateTo(0),
        );
      }

      return Column(
        children: [
          _buildAnimatedHeader(
            icon: Icons.favorite,
            count: state.favoriteServices.length,
            label: state.favoriteServices.length == 1
                ? AppConstants.favoriteService
                : AppConstants.favoriteServices,
            colors: AppColors.redPinkGradient,
            iconColor: AppColors.favoriteRed,
          ),
          Expanded(
            child: ServicesListView(
              services: state.favoriteServices,
              onFavoriteToggle: (service) {
                context.read<ServicesCubit>().toggleServiceFavorite(service);
              },
              emptyStateMessage: AppConstants.noFavoriteServices,
              emptyStateIcon: Icons.favorite_border,
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildAnimatedHeader({
    required IconData icon,
    required int count,
    required String label,
    required List<Color> colors,
    required Color iconColor,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      width: double.infinity,
      padding: AppConstants.paddingAll16,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: TweenAnimationBuilder<double>(
        duration: AppConstants.slowAnimation,
        tween: Tween(
            begin: AppConstants.opacityTransparent,
            end: AppConstants.opacityOpaque
        ),
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: Opacity(
              opacity: value,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppConstants.borderRadius8),
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(AppConstants.opacityLow),
                      borderRadius: BorderRadius.circular(AppConstants.borderRadius8),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: AppConstants.iconTiny,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '$count $label',
                    style: TextStyle(
                      color: AppColors.greyText700,
                      fontWeight: FontWeight.w600,
                      fontSize: AppConstants.fontSizeLarge,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}