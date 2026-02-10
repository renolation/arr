import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/empty_state.dart';
import '../providers/requests_provider.dart';
import '../widgets/approval_card.dart';

/// Requests page showing media requests from Overseerr
class RequestsPage extends ConsumerWidget {
  const RequestsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(requestFilterProvider);
    final filteredRequests = ref.watch(filteredRequestsProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('Requests'),
            floating: true,
            actions: [
              PopupMenuButton<RequestFilter>(
                icon: const Icon(Icons.filter_list),
                onSelected: (value) {
                  ref.read(requestFilterProvider.notifier).state = value;
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: RequestFilter.all,
                    child: Text('All Requests'),
                  ),
                  const PopupMenuItem(
                    value: RequestFilter.pending,
                    child: Text('Pending'),
                  ),
                  const PopupMenuItem(
                    value: RequestFilter.approved,
                    child: Text('Approved'),
                  ),
                ],
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: filteredRequests.isEmpty
                ? SliverToBoxAdapter(
                    child: EmptyState(
                      message: _getEmptyMessage(filter),
                      icon: Icons.request_page_outlined,
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final request = filteredRequests[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ApprovalCard(request: request),
                        );
                      },
                      childCount: filteredRequests.length,
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNewRequestDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  String _getEmptyMessage(RequestFilter filter) {
    switch (filter) {
      case RequestFilter.pending:
        return 'No pending requests';
      case RequestFilter.approved:
        return 'No approved requests';
      default:
        return 'No requests yet';
    }
  }

  void _showNewRequestDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Request'),
        content: const Text('Request new media functionality coming soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
