import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/enums/progress_unit.dart';
import '../../domain/enums/publication_status.dart';
import '../../domain/enums/reading_status.dart';
import '../../domain/enums/work_format.dart';
import '../../providers/settings_provider.dart';
import '../shared/star_rating.dart';
import 'add_edit_work_view_model.dart';
import 'tag_input_field.dart';

class AddEditWorkScreen extends ConsumerStatefulWidget {
  final String? workId;

  const AddEditWorkScreen({super.key, this.workId});

  @override
  ConsumerState<AddEditWorkScreen> createState() => _AddEditWorkScreenState();
}

class _AddEditWorkScreenState extends ConsumerState<AddEditWorkScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _sourceUrlController;
  late TextEditingController _coverPathController;
  late TextEditingController _synopsisController;
  late TextEditingController _notesController;
  late TextEditingController _currentProgressController;
  late TextEditingController _totalProgressController;
  late TextEditingController _currentVolumeController;
  late TextEditingController _totalVolumesController;

  ReadingStatus _status = ReadingStatus.reading;
  PublicationStatus _pubStatus = PublicationStatus.ongoing;
  WorkFormat _format = WorkFormat.webNovel;
  ProgressUnit _progressUnit = ProgressUnit.chapter;

  int? _rating;
  DateTime? _startedDate;
  DateTime? _completedDate;
  List<String> _tags = [];
  List<String> _additionalUrls = [];
  bool _isMoreExpanded = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _authorController = TextEditingController();
    _sourceUrlController = TextEditingController();
    _coverPathController = TextEditingController();
    _synopsisController = TextEditingController();
    _notesController = TextEditingController();
    _currentProgressController = TextEditingController(text: '0');
    _totalProgressController = TextEditingController();
    _currentVolumeController = TextEditingController();
    _totalVolumesController = TextEditingController();

    _loadExistingOrDefaults();
  }

  Future<void> _loadExistingOrDefaults() async {
    if (widget.workId != null) {
      final vm = ref.read(addEditWorkViewModelProvider);
      final work = await vm.loadWork(widget.workId!);

      if (work != null) {
        _titleController.text = work.title;
        _authorController.text = work.author ?? '';
        _sourceUrlController.text = work.sourceUrl ?? '';
        _coverPathController.text = work.coverPath ?? '';
        _synopsisController.text = work.synopsis ?? '';
        _notesController.text = work.notes ?? '';
        _currentProgressController.text = work.currentProgress.toString();
        _totalProgressController.text = work.totalProgress?.toString() ?? '';
        _currentVolumeController.text = work.currentVolume?.toString() ?? '';
        _totalVolumesController.text = work.totalVolumes?.toString() ?? '';

        _status = work.readStatus;
        _pubStatus = work.pubStatus;
        _format = work.workFormat;
        _progressUnit = work.unit;
        _rating = work.rating;
        _startedDate = work.startedAt;
        _completedDate = work.completedAt;
        _tags = List.from(work.tags);
        _additionalUrls = List.from(work.additionalUrls);

        _isMoreExpanded = true; // Expand when editing existing work
      }
    } else {
      final defaultUnit = ref.read(settingsProvider).defaultProgressUnit;
      _progressUnit = defaultUnit;
      _startedDate = DateTime.now();
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _sourceUrlController.dispose();
    _coverPathController.dispose();
    _synopsisController.dispose();
    _notesController.dispose();
    _currentProgressController.dispose();
    _totalProgressController.dispose();
    _currentVolumeController.dispose();
    _totalVolumesController.dispose();
    super.dispose();
  }

  void _detectDomainAndSuggest(String url) {
    final suggestion = ref.read(addEditWorkViewModelProvider).detectDomain(url);
    if (suggestion.suggestedFormat != null || suggestion.suggestedTag != null) {
      setState(() {
        if (suggestion.suggestedFormat != null) {
          _format = suggestion.suggestedFormat!;
        }
        if (suggestion.suggestedTag != null &&
            !_tags.contains(suggestion.suggestedTag)) {
          _tags.add(suggestion.suggestedTag!);
        }
      });
    }
  }

  Future<void> _pickCoverImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _coverPathController.text = image.path;
      });
    }
  }

  Future<void> _saveWork() async {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text.trim();
    final author = _authorController.text.trim().isEmpty
        ? null
        : _authorController.text.trim();
    final sourceUrl = _sourceUrlController.text.trim().isEmpty
        ? null
        : _sourceUrlController.text.trim();
    final coverPath = _coverPathController.text.trim().isEmpty
        ? null
        : _coverPathController.text.trim();
    final synopsis = _synopsisController.text.trim().isEmpty
        ? null
        : _synopsisController.text.trim();
    final notes = _notesController.text.trim().isEmpty
        ? null
        : _notesController.text.trim();

    final currentProgress =
        int.tryParse(_currentProgressController.text.trim()) ?? 0;
    final totalProgress = int.tryParse(_totalProgressController.text.trim());
    final currentVolume = _progressUnit == ProgressUnit.volumeChapter
        ? int.tryParse(_currentVolumeController.text.trim())
        : null;
    final totalVolumes = _progressUnit == ProgressUnit.volumeChapter
        ? int.tryParse(_totalVolumesController.text.trim())
        : null;

    final vm = ref.read(addEditWorkViewModelProvider);
    final result = await vm.saveWork(
      id: widget.workId,
      title: title,
      author: author,
      sourceUrl: sourceUrl,
      additionalUrls: _additionalUrls,
      format: _format,
      status: _status,
      publicationStatus: _pubStatus,
      coverPath: coverPath,
      progressUnit: _progressUnit,
      currentProgress: currentProgress,
      totalProgress: totalProgress,
      currentVolume: currentVolume,
      totalVolumes: totalVolumes,
      rating: _rating,
      synopsis: synopsis,
      notes: notes,
      tags: _tags,
      startedAt: _startedDate,
      completedAt: _completedDate,
    );

    if (!mounted) return;

    result.fold(
      onSuccess: (_) => context.pop(),
      onFailure: (err, _) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save: $err'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEditing = widget.workId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Work' : 'Add Work'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_rounded),
            tooltip: 'Save',
            onPressed: _saveWork,
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              children: [
                // Core Field: Title
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title *',
                    hintText: 'e.g. Super Supportive, Worm, Mother of Learning',
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Title is required';
                    }
                    if (val.trim().length > 500) {
                      return 'Title must be 500 characters or less';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Core Field: Status
                Text(
                  'Shelf / Status',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SegmentedButton<ReadingStatus>(
                    segments: ReadingStatus.values.map((s) {
                      return ButtonSegment(value: s, label: Text(s.label));
                    }).toList(),
                    selected: {_status},
                    onSelectionChanged: (set) {
                      setState(() {
                        _status = set.first;
                        if (_status == ReadingStatus.reading &&
                            _startedDate == null) {
                          _startedDate = DateTime.now();
                        }
                        if (_status == ReadingStatus.completed &&
                            _completedDate == null) {
                          _completedDate = DateTime.now();
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Reading Dates (Started & Completed)
                Row(
                  children: [
                    Expanded(
                      child: _buildDatePickerTile(
                        context: context,
                        label: 'Started Date',
                        date: _startedDate,
                        onDateChanged: (val) =>
                            setState(() => _startedDate = val),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDatePickerTile(
                        context: context,
                        label: 'Finished Date',
                        date: _completedDate,
                        onDateChanged: (val) =>
                            setState(() => _completedDate = val),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Core Field: Progress Unit
                Text(
                  'Track Progress By',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: ProgressUnit.values.map((u) {
                    final isSelected = _progressUnit == u;
                    return ChoiceChip(
                      label: Text(u.label),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            if (u == ProgressUnit.volume &&
                                _progressUnit == ProgressUnit.volumeChapter) {
                              if (_currentVolumeController.text.isNotEmpty &&
                                  _currentVolumeController.text != '0') {
                                _currentProgressController.text =
                                    _currentVolumeController.text;
                              }
                              if (_totalVolumesController.text.isNotEmpty) {
                                _totalProgressController.text =
                                    _totalVolumesController.text;
                              }
                            } else if (u == ProgressUnit.volumeChapter &&
                                _progressUnit == ProgressUnit.volume) {
                              if (_currentProgressController.text.isNotEmpty &&
                                  _currentProgressController.text != '0') {
                                _currentVolumeController.text =
                                    _currentProgressController.text;
                                _currentProgressController.text = '0';
                              }
                              if (_totalProgressController.text.isNotEmpty) {
                                _totalVolumesController.text =
                                    _totalProgressController.text;
                                _totalProgressController.text = '';
                              }
                            }
                            _progressUnit = u;
                          });
                        }
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // Core Field: Progress inputs with stepper
                _buildProgressInputs(context),
                const SizedBox(height: 24),

                // Expandable section header
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    setState(() {
                      _isMoreExpanded = !_isMoreExpanded;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.35,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Additional Details',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(
                          _isMoreExpanded
                              ? Icons.expand_less_rounded
                              : Icons.expand_more_rounded,
                          color: colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ),

                if (_isMoreExpanded) ...[
                  const SizedBox(height: 20),

                  // Author
                  TextFormField(
                    controller: _authorController,
                    decoration: const InputDecoration(
                      labelText: 'Author / Creator',
                      hintText: 'e.g. Sleyca, Wildbow, Zorian',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Primary Source URL
                  TextFormField(
                    controller: _sourceUrlController,
                    decoration: const InputDecoration(
                      labelText: 'Source URL',
                      hintText: 'https://royalroad.com/fiction/...',
                      prefixIcon: Icon(Icons.link_rounded),
                    ),
                    onChanged: _detectDomainAndSuggest,
                    validator: (val) {
                      if (val != null && val.trim().isNotEmpty) {
                        final uri = Uri.tryParse(val.trim());
                        if (uri == null ||
                            (!uri.isScheme('http') && !uri.isScheme('https'))) {
                          return 'Enter a valid URL (starting with http:// or https://)';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Format & Publication Status
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<WorkFormat>(
                          initialValue: _format,
                          decoration: const InputDecoration(
                            labelText: 'Format',
                          ),
                          items: WorkFormat.values.map((f) {
                            return DropdownMenuItem(
                              value: f,
                              child: Text(f.label),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _format = val);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<PublicationStatus>(
                          initialValue: _pubStatus,
                          decoration: const InputDecoration(
                            labelText: 'Serialization',
                          ),
                          items: PublicationStatus.values.map((p) {
                            return DropdownMenuItem(
                              value: p,
                              child: Text(p.label),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _pubStatus = val);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Cover Image Path / URL + Gallery Button
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _coverPathController,
                          decoration: const InputDecoration(
                            labelText: 'Cover (URL or File)',
                            hintText: 'Paste web image URL or select file',
                            prefixIcon: Icon(Icons.image_outlined),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filledTonal(
                        icon: const Icon(Icons.photo_library_outlined),
                        tooltip: 'Pick from Gallery',
                        onPressed: _pickCoverImage,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Star Rating
                  Row(
                    children: [
                      Text(
                        'Rating:',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      StarRatingWidget(
                        rating: _rating,
                        size: 28,
                        showNumber: true,
                        onRatingChanged: (val) {
                          setState(() {
                            _rating = val;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Tags
                  Text(
                    'Tags / Fandoms',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TagInputField(
                    initialTags: _tags,
                    onTagsChanged: (tags) {
                      _tags = tags;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Synopsis
                  TextFormField(
                    controller: _synopsisController,
                    decoration: const InputDecoration(
                      labelText: 'Synopsis / Blurb',
                      hintText: 'Brief summary of the work...',
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),

                  // Personal Notes
                  TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      labelText: 'Personal Notes & Impressions',
                      hintText:
                          'Bookmarked arcs, review thoughts, reminders...',
                    ),
                    maxLines: 4,
                  ),
                  const SizedBox(height: 24),
                ],

                // Save Button
                FilledButton.icon(
                  onPressed: _saveWork,
                  icon: const Icon(Icons.save_rounded),
                  label: Text(isEditing ? 'Update Work' : 'Add to Library'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressInputs(BuildContext context) {
    switch (_progressUnit) {
      case ProgressUnit.chapter:
        return Row(
          children: [
            Expanded(
              child: _buildStepperField(
                controller: _currentProgressController,
                label: 'Current Chapter *',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _totalProgressController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Total Chapters',
                  hintText: 'Optional',
                ),
              ),
            ),
          ],
        );

      case ProgressUnit.page:
        return Row(
          children: [
            Expanded(
              child: _buildStepperField(
                controller: _currentProgressController,
                label: 'Current Page *',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _totalProgressController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Total Pages',
                  hintText: 'Optional',
                ),
              ),
            ),
          ],
        );

      case ProgressUnit.volume:
        return Row(
          children: [
            Expanded(
              child: _buildStepperField(
                controller: _currentProgressController,
                label: 'Current Volume *',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _totalProgressController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Total Volumes',
                  hintText: 'Optional',
                ),
              ),
            ),
          ],
        );

      case ProgressUnit.volumeChapter:
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildStepperField(
                    controller: _currentVolumeController,
                    label: 'Current Volume',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _totalVolumesController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Total Volumes',
                      hintText: 'Optional',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStepperField(
                    controller: _currentProgressController,
                    label: 'Current Chapter *',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _totalProgressController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Total Chapters',
                      hintText: 'Optional',
                    ),
                  ),
                ),
              ],
            ),
          ],
        );

      case ProgressUnit.words:
        return Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _currentProgressController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Words Read *',
                  hintText: 'e.g. 150000',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _totalProgressController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Total Words',
                  hintText: 'Optional',
                ),
              ),
            ),
          ],
        );

      case ProgressUnit.percent:
        return Row(
          children: [
            Expanded(
              child: _buildStepperField(
                controller: _currentProgressController,
                label: 'Progress Percentage (0-100) *',
                step: 5,
              ),
            ),
          ],
        );
    }
  }

  Widget _buildStepperField({
    required TextEditingController controller,
    required String label,
    int step = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: IconButton(
          icon: const Icon(Icons.remove_rounded),
          onPressed: () {
            final val = int.tryParse(controller.text) ?? 0;
            if (val > 0) {
              controller.text = (val - step).toString();
            }
          },
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.add_rounded),
          onPressed: () {
            final val = int.tryParse(controller.text) ?? 0;
            controller.text = (val + step).toString();
          },
        ),
      ),
      validator: (val) {
        if (val == null || val.trim().isEmpty) {
          return 'Required';
        }
        final n = int.tryParse(val.trim());
        if (n == null || n < 0) {
          return 'Must be ≥ 0';
        }
        if (_progressUnit == ProgressUnit.percent && n > 100) {
          return 'Max 100%';
        }
        return null;
      },
    );
  }

  Widget _buildDatePickerTile({
    required BuildContext context,
    required String label,
    required DateTime? date,
    required ValueChanged<DateTime?> onDateChanged,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dateFormat = DateFormat('MMM d, y');

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(
          color: date != null
              ? colorScheme.primary
              : colorScheme.outlineVariant,
        ),
      ),
      onPressed: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? now,
          firstDate: DateTime(1970),
          lastDate: DateTime(now.year + 5),
        );
        if (picked != null) {
          onDateChanged(picked);
        }
      },
      child: Row(
        children: [
          Icon(
            Icons.calendar_today_rounded,
            size: 16,
            color: date != null
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  date != null ? dateFormat.format(date) : 'Not set',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: date != null
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: date != null
                        ? colorScheme.onSurface
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (date != null)
            GestureDetector(
              onTap: () => onDateChanged(null),
              child: Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
