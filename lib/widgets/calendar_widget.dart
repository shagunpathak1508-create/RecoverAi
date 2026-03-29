import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../theme.dart';
import '../widgets/section_card.dart';

/// Doctor Follow-Up Calendar widget.
///
/// Displays a monthly calendar view with:
///   - Green dates = available slots
///   - Grey/Red dates = booked slots
///   - Tap to select → pick a time slot → confirm booking
class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String? _selectedTimeSlot;
  String? _confirmedMessage;

  // ── Dummy Data ─────────────────────────────────────────────────────
  // Booked dates (simulated)
  final Set<DateTime> _bookedDates = {
    DateTime.now().add(const Duration(days: 2)),
    DateTime.now().add(const Duration(days: 5)),
    DateTime.now().add(const Duration(days: 8)),
    DateTime.now().subtract(const Duration(days: 1)),
  };

  // Available time slots (dummy)
  final List<String> _timeSlots = [
    '09:00 AM',
    '10:30 AM',
    '12:00 PM',
    '02:00 PM',
    '03:30 PM',
    '05:00 PM',
  ];

  bool _isBooked(DateTime day) {
    return _bookedDates.any((d) =>
        d.year == day.year && d.month == day.month && d.day == day.day);
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    // Don't allow selecting past dates or booked dates
    if (selectedDay.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      return;
    }

    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _selectedTimeSlot = null;
      _confirmedMessage = null;
    });
  }

  void _confirmBooking() {
    if (_selectedDay == null || _selectedTimeSlot == null) return;

    final dateStr =
        '${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}';

    setState(() {
      _bookedDates.add(_selectedDay!);
      _confirmedMessage =
          'Follow-up scheduled for patient on $dateStr at $_selectedTimeSlot';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ Follow-up booked: $dateStr at $_selectedTimeSlot'),
        backgroundColor: kSuccess,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Suggested Follow-up',
      icon: Icons.calendar_month_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Legend ─────────────────────────────────────────────────
          Row(
            children: [
              _legendItem(kSuccess, 'Available'),
              const SizedBox(width: 16),
              _legendItem(Colors.grey, 'Booked'),
              const SizedBox(width: 16),
              _legendItem(kPrimary, 'Selected'),
            ],
          ),
          const SizedBox(height: 12),

          // ── Calendar ──────────────────────────────────────────────
          TableCalendar(
            firstDay: DateTime.now().subtract(const Duration(days: 30)),
            lastDay: DateTime.now().add(const Duration(days: 90)),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: _onDaySelected,
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarFormat: CalendarFormat.month,
            availableCalendarFormats: const {CalendarFormat.month: 'Month'},
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kTextPrimary,
              ),
              leftChevronIcon:
                  Icon(Icons.chevron_left_rounded, color: kPrimary),
              rightChevronIcon:
                  Icon(Icons.chevron_right_rounded, color: kPrimary),
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: kTextSecondary),
              weekendStyle: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: kTextSecondary),
            ),
            calendarStyle: CalendarStyle(
              // Today
              todayDecoration: BoxDecoration(
                color: kPrimary.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              todayTextStyle: const TextStyle(
                  color: kPrimary, fontWeight: FontWeight.bold),
              // Selected
              selectedDecoration: const BoxDecoration(
                color: kPrimary,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
              // Default
              defaultTextStyle:
                  const TextStyle(fontSize: 15, color: kTextPrimary),
              weekendTextStyle:
                  const TextStyle(fontSize: 15, color: kTextSecondary),
              outsideDaysVisible: false,
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                if (_isBooked(day)) {
                  return _buildDayCell(day, Colors.grey.shade400, Colors.white);
                }
                // Future available days get green tint
                if (day.isAfter(DateTime.now())) {
                  return _buildDayCell(
                      day, kSuccess.withOpacity(0.15), kSuccess);
                }
                return null; // use default
              },
              todayBuilder: (context, day, focusedDay) {
                if (_isBooked(day)) {
                  return _buildDayCell(day, Colors.grey.shade400, Colors.white);
                }
                return _buildDayCell(
                    day, kPrimary.withOpacity(0.2), kPrimary);
              },
            ),
          ),
          const SizedBox(height: 16),

          // ── Time Slot Selection ────────────────────────────────────
          if (_selectedDay != null && !_isBooked(_selectedDay!)) ...[
            Text(
              'Select a time slot for ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}:',
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: kTextPrimary),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _timeSlots.map((slot) {
                final isSelected = _selectedTimeSlot == slot;
                return GestureDetector(
                  onTap: () => setState(() => _selectedTimeSlot = slot),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? kPrimary : kPrimary.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? kPrimary
                            : kPrimary.withOpacity(0.25),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      slot,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : kPrimary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // ── Confirm Button ───────────────────────────────────────
            if (_selectedTimeSlot != null)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kSuccess,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.check_circle_rounded, size: 24),
                  label: const Text('Confirm Follow-up',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  onPressed: _confirmBooking,
                ),
              ),
          ],

          if (_selectedDay != null && _isBooked(_selectedDay!))
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.event_busy_rounded, color: Colors.grey),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'This date is already booked.',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700),
                    ),
                  ),
                ],
              ),
            ),

          // ── Confirmation Message ───────────────────────────────────
          if (_confirmedMessage != null) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: kSuccess.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kSuccess.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded,
                      color: kSuccess, size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _confirmedMessage!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: kSuccess,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDayCell(DateTime day, Color bgColor, Color textColor) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        '${day.day}',
        style: TextStyle(
            fontSize: 15, fontWeight: FontWeight.bold, color: textColor),
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color.withOpacity(0.7),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 1.5),
          ),
        ),
        const SizedBox(width: 5),
        Text(label,
            style: const TextStyle(fontSize: 12, color: kTextSecondary)),
      ],
    );
  }
}
