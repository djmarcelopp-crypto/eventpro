import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/catalog_image_services_provider.dart';
import 'catalog_item_image_placeholder.dart';

class CatalogItemImageView extends ConsumerStatefulWidget {
  const CatalogItemImageView({
    super.key,
    this.imageReference,
    this.width = 160,
    this.height = 120,
    this.borderRadius = 12,
  });

  final String? imageReference;
  final double width;
  final double height;
  final double borderRadius;

  @override
  ConsumerState<CatalogItemImageView> createState() =>
      _CatalogItemImageViewState();
}

class _CatalogItemImageViewState extends ConsumerState<CatalogItemImageView> {
  Uint8List? _bytes;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(covariant CatalogItemImageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageReference != widget.imageReference) {
      _loadImage();
    }
  }

  Future<void> _loadImage() async {
    final reference = widget.imageReference;
    if (reference == null) {
      if (mounted) {
        setState(() {
          _bytes = null;
          _failed = false;
        });
      }
      return;
    }

    final cache = ref.read(catalogImageMemoryCacheProvider);
    final cached = cache.get(reference);
    if (cached != null) {
      if (mounted) {
        setState(() {
          _bytes = cached;
          _failed = false;
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        _failed = false;
        _bytes = null;
      });
    }

    final storage = ref.read(catalogImageStorageProvider);
    if (!await storage.exists(reference)) {
      if (mounted) {
        setState(() {
          _failed = true;
          _bytes = null;
        });
      }
      return;
    }

    final bytes = await storage.readBytes(reference);
    if (!mounted) {
      return;
    }

    setState(() {
      _bytes = bytes;
      _failed = bytes == null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageReference == null || _failed) {
      return CatalogItemImagePlaceholder(
        width: widget.width,
        height: widget.height,
        borderRadius: widget.borderRadius,
      );
    }

    if (_bytes == null) {
      return CatalogItemImagePlaceholder(
        width: widget.width,
        height: widget.height,
        borderRadius: widget.borderRadius,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Image.memory(
        _bytes!,
        width: widget.width,
        height: widget.height,
        fit: BoxFit.cover,
        gaplessPlayback: true,
        errorBuilder: (_, _, _) {
          return CatalogItemImagePlaceholder(
            width: widget.width,
            height: widget.height,
            borderRadius: widget.borderRadius,
          );
        },
      ),
    );
  }
}
