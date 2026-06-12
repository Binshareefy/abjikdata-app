import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppShell extends StatefulWidget {
  final Widget child;
  final int currentIndex;
  final Function(int) onTabChange;

  const AppShell({
    super.key,
    required this.child,
    this.currentIndex = 0,
    required this.onTabChange,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(4, (i) {
      return AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
      );
    });
    _animations = _controllers.map((c) {
      return CurvedAnimation(parent: c, curve: Curves.easeOutBack);
    }).toList();
    // Animate the current tab
    _controllers[widget.currentIndex].value = 1.0;
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _onTabChange(int index) {
    for (var c in _controllers) {
      c.reverse();
    }
    _controllers[index].forward();
    widget.onTabChange(index);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: widget.child),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(
                    icon: Icons.home_rounded,
                    label: 'Home',
                    index: 0,
                    currentIndex: widget.currentIndex,
                    animation: _animations[0],
                    onTap: () => _onTabChange(0),
                  ),
                  _NavItem(
                    icon: Icons.wifi_rounded,
                    label: 'Data',
                    index: 1,
                    currentIndex: widget.currentIndex,
                    animation: _animations[1],
                    onTap: () => _onTabChange(1),
                  ),
                  _NavItem(
                    icon: Icons.receipt_long_rounded,
                    label: 'History',
                    index: 2,
                    currentIndex: widget.currentIndex,
                    animation: _animations[2],
                    onTap: () => _onTabChange(2),
                  ),
                  _NavItem(
                    icon: Icons.share_rounded,
                    label: 'Referral',
                    index: 3,
                    currentIndex: widget.currentIndex,
                    animation: _animations[3],
                    onTap: () => _onTabChange(3),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int currentIndex;
  final Animation<double> animation;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.animation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 + (animation.value * 0.15),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 24,
                    color: isSelected ? AppColors.primary : AppColors.muted,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      color:
                          isSelected ? AppColors.primary : AppColors.muted,
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

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBack;

  const AppBarWidget({
    super.key,
    required this.title,
    this.actions,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      leading: showBack
          ? IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.bg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_back_ios_new, size: 16),
              ),
              onPressed: () => Navigator.pop(context),
            )
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
