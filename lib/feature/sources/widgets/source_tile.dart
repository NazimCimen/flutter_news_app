part of '../view/select_sources_view.dart';

///  SOURCE TILE
class _SourceTile extends ConsumerWidget {
  final SourceModel source;

  const _SourceTile({required this.source});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: _buildLeading(context),
          title: Text(
            source.name ?? '',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
          ),
          trailing: Switch(
            thumbColor: WidgetStatePropertyAll<Color>(
              Theme.of(context).colorScheme.onSurface,
            ),

            value: source.isFollowed ?? false,
            onChanged: (_) => ref
                .read(selectSourcesViewModelProvider.notifier)
                .toggleFollow(source.id ?? ''),
            activeColor: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.2),
            activeTrackColor: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.2),
            inactiveTrackColor: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.1),
          ),
        ),
        Divider(
          thickness: 0.7,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
        ),
      ],
    );
  }

  Widget _buildLeading(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: source.imageUrl != null
          ? CachedNetworkImage(
              imageUrl: source.imageUrl!,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest,
                highlightColor: Theme.of(context).colorScheme.surface,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Icon(
                Icons.article,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            )
          : Icon(
              Icons.article,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
    );
  }
}
