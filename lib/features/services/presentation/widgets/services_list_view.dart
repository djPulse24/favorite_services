import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/service.dart';
import 'service_list_item.dart';
import 'animated_empty_state_widget.dart';

class ServicesListView extends StatelessWidget {
  final List<Service> services;
  final Function(Service) onFavoriteToggle;
  final VoidCallback? onRefresh;
  final bool showEmptyState;
  final String emptyStateMessage;
  final IconData emptyStateIcon;

  const ServicesListView({
    Key? key,
    required this.services,
    required this.onFavoriteToggle,
    this.onRefresh,
    this.showEmptyState = true,
    this.emptyStateMessage = AppConstants.noServicesAvailable,
    this.emptyStateIcon = Icons.business_outlined,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty && showEmptyState) {
      return AnimatedEmptyStateWidget(
        icon: emptyStateIcon,
        message: emptyStateMessage,
        showSubtitle: emptyStateMessage.contains('favorite'),
      );
    }

    Widget listView = ListView.builder(
      key: const ValueKey('services_list'),
      padding: AppConstants.paddingVertical8,
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 200 + (index * 100)),
          tween: Tween(
            begin: AppConstants.opacityTransparent,
            end: AppConstants.opacityOpaque,
          ),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 50 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: ServiceListItem(
                  service: service,
                  onFavoriteToggle: () => onFavoriteToggle(service),
                  index: index,
                ),
              ),
            );
          },
        );
      },
    );

    if (onRefresh != null) {
      return RefreshIndicator(
        onRefresh: () async {
          onRefresh?.call();
        },
        color: Theme.of(context).primaryColor,
        backgroundColor: AppColors.backgroundWhite,
        strokeWidth: 3.0,
        child: listView,
      );
    }

    return listView;
  }
}
