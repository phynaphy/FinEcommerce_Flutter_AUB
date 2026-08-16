import 'package:flutter/material.dart';

class HomeBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const HomeBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final List<_NavItem> items = const [
    _NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_filled,
      label: 'Home',
    ),
    _NavItem(
      icon: Icons.grid_view_outlined,
      activeIcon: Icons.grid_view_rounded,
      label: 'Categories',
    ),
    _NavItem(
      icon: Icons.shopping_cart_outlined,
      activeIcon: Icons.shopping_cart,
      label: 'Cart',
    ),
    _NavItem(
      icon: Icons.favorite_border,
      activeIcon: Icons.favorite,
      label: 'Wishlist',
    ),
    _NavItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            items.length,
            (index) => Expanded(
              child: _buildNavItem(
                item: items[index],
                index: index,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required _NavItem item,
    required int index,
  }) {
    final bool isSelected = currentIndex == index;

    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 4,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF003D91).withOpacity(0.10)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? item.activeIcon : item.icon,
                key: ValueKey(isSelected),
                color: isSelected
                    ? const Color(0xFF003D91)
                    : const Color(0xFF94A3B8),
                size: isSelected ? 26 : 24,
              ),
            ),

            const SizedBox(height: 4),

            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: isSelected ? 11 : 10,
                fontWeight: isSelected
                    ? FontWeight.w700
                    : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF003D91)
                    : const Color(0xFF94A3B8),
              ),
              child: Text(
                item.label,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}