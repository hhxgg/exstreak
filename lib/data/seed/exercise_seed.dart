import '../../domain/enums.dart';

/// A row in the built-in exercise catalogue.
///
/// Seeds are matched on [slug]. On upgrade, existing rows are updated in place
/// and new slugs are inserted, so a user's history and custom exercises survive
/// catalogue changes.
class ExerciseSeed {
  const ExerciseSeed({
    required this.slug,
    required this.name,
    required this.muscleGroup,
    required this.equipment,
    required this.difficulty,
    required this.trackingType,
    required this.iconName,
    required this.description,
    required this.instructions,
    this.isBodyweight = true,
    this.intensityFactor = 1.0,
    this.defaultRestSeconds = 90,
  });

  final String slug;
  final String name;
  final MuscleGroup muscleGroup;
  final Equipment equipment;
  final Difficulty difficulty;
  final TrackingType trackingType;
  final String iconName;
  final String description;
  final List<String> instructions;
  final bool isBodyweight;
  final double intensityFactor;
  final int defaultRestSeconds;
}

/// The catalogue shipped with the app.
///
/// Adding an exercise is a single entry here — no screen, chart or stats code
/// needs to change, because everything branches on [TrackingType].
abstract final class ExerciseSeeds {
  static const List<ExerciseSeed> all = [
    // ---------------------------------------------------------------- chest
    ExerciseSeed(
      slug: 'pushup',
      name: 'Push-ups',
      muscleGroup: MuscleGroup.chest,
      equipment: Equipment.none,
      difficulty: Difficulty.beginner,
      trackingType: TrackingType.reps,
      iconName: 'pushup',
      description:
          'The cornerstone bodyweight press. Builds chest, shoulders and '
          'triceps while teaching full-body tension.',
      instructions: [
        'Hands slightly wider than shoulders, fingers spread.',
        'Squeeze glutes and brace your core so hips do not sag.',
        'Lower until your chest is a fist above the floor.',
        'Press back up without letting the elbows flare past 45°.',
      ],
      intensityFactor: 1.0,
      defaultRestSeconds: 90,
    ),
    ExerciseSeed(
      slug: 'incline-pushup',
      name: 'Incline push-ups',
      muscleGroup: MuscleGroup.chest,
      equipment: Equipment.none,
      difficulty: Difficulty.beginner,
      trackingType: TrackingType.reps,
      iconName: 'pushup',
      description:
          'Push-ups with hands elevated on a bench or step. The easiest way '
          'to build up to full push-ups.',
      instructions: [
        'Place your hands on a stable raised surface.',
        'Walk your feet back until your body is a straight line.',
        'Lower your chest to the edge, then press away.',
        'Lower the surface as you get stronger.',
      ],
      intensityFactor: 0.7,
      defaultRestSeconds: 75,
    ),
    ExerciseSeed(
      slug: 'diamond-pushup',
      name: 'Diamond push-ups',
      muscleGroup: MuscleGroup.arms,
      equipment: Equipment.none,
      difficulty: Difficulty.advanced,
      trackingType: TrackingType.reps,
      iconName: 'pushup',
      description:
          'Narrow-hand push-ups that shift most of the load onto the triceps.',
      instructions: [
        'Form a diamond with thumbs and index fingers under your chest.',
        'Keep elbows tucked close to your ribs on the way down.',
        'Touch your chest to your hands, then press up.',
      ],
      intensityFactor: 1.4,
      defaultRestSeconds: 105,
    ),
    ExerciseSeed(
      slug: 'wide-pushup',
      name: 'Wide push-ups',
      muscleGroup: MuscleGroup.chest,
      equipment: Equipment.none,
      difficulty: Difficulty.intermediate,
      trackingType: TrackingType.reps,
      iconName: 'pushup',
      description: 'A wider hand position that biases the chest over the arms.',
      instructions: [
        'Set hands roughly one and a half shoulder widths apart.',
        'Lower with control — the range is shorter than a standard push-up.',
        'Stop if you feel pinching at the front of the shoulder.',
      ],
      intensityFactor: 1.1,
      defaultRestSeconds: 90,
    ),
    ExerciseSeed(
      slug: 'bench-press',
      name: 'Bench press',
      muscleGroup: MuscleGroup.chest,
      equipment: Equipment.barbell,
      difficulty: Difficulty.intermediate,
      trackingType: TrackingType.repsWeight,
      iconName: 'press',
      description: 'The classic loaded horizontal press for chest strength.',
      instructions: [
        'Set your shoulder blades down and back into the bench.',
        'Grip just outside shoulder width, wrists stacked over elbows.',
        'Lower to mid-chest, touch, then drive the bar up and slightly back.',
        'Always use a spotter or safety pins when working near a maximum.',
      ],
      isBodyweight: false,
      intensityFactor: 1.6,
      defaultRestSeconds: 150,
    ),
    ExerciseSeed(
      slug: 'dip',
      name: 'Dips',
      muscleGroup: MuscleGroup.chest,
      equipment: Equipment.none,
      difficulty: Difficulty.advanced,
      trackingType: TrackingType.reps,
      iconName: 'dip',
      description:
          'A vertical press between parallel bars. Heavy on chest, front '
          'shoulders and triceps.',
      instructions: [
        'Start locked out with shoulders down, not shrugged.',
        'Lean forward slightly to bias the chest, stay upright for triceps.',
        'Lower until your upper arms are roughly parallel to the floor.',
        'Press back to lockout without bouncing out of the bottom.',
      ],
      intensityFactor: 1.7,
      defaultRestSeconds: 120,
    ),

    // ------------------------------------------------------------------ back
    ExerciseSeed(
      slug: 'pullup',
      name: 'Pull-ups',
      muscleGroup: MuscleGroup.back,
      equipment: Equipment.pullUpBar,
      difficulty: Difficulty.advanced,
      trackingType: TrackingType.reps,
      iconName: 'pullup',
      description:
          'Overhand vertical pull. The benchmark for upper-body pulling '
          'strength.',
      instructions: [
        'Hang with an overhand grip just outside shoulder width.',
        'Pull your shoulder blades down before you bend your arms.',
        'Drive elbows to your ribs until your chin clears the bar.',
        'Lower all the way to a dead hang under control.',
      ],
      intensityFactor: 2.0,
      defaultRestSeconds: 150,
    ),
    ExerciseSeed(
      slug: 'chinup',
      name: 'Chin-ups',
      muscleGroup: MuscleGroup.back,
      equipment: Equipment.pullUpBar,
      difficulty: Difficulty.intermediate,
      trackingType: TrackingType.reps,
      iconName: 'pullup',
      description:
          'Underhand vertical pull. Easier than a pull-up and far more biceps.',
      instructions: [
        'Grip the bar underhand at shoulder width.',
        'Keep ribs down so you do not arch into the rep.',
        'Pull until your collarbone approaches the bar.',
        'Control the descent — that is where the strength is built.',
      ],
      intensityFactor: 1.8,
      defaultRestSeconds: 150,
    ),
    ExerciseSeed(
      slug: 'dumbbell-row',
      name: 'Dumbbell rows',
      muscleGroup: MuscleGroup.back,
      equipment: Equipment.dumbbell,
      difficulty: Difficulty.beginner,
      trackingType: TrackingType.repsWeight,
      iconName: 'row',
      description:
          'Single-arm horizontal pull. Kind to the lower back and easy to load '
          'progressively.',
      instructions: [
        'Brace one hand and knee on a bench, back flat.',
        'Let the dumbbell hang, then row it toward your hip.',
        'Keep the shoulder down; do not twist your torso to finish the rep.',
      ],
      isBodyweight: false,
      intensityFactor: 1.2,
      defaultRestSeconds: 90,
    ),
    ExerciseSeed(
      slug: 'barbell-row',
      name: 'Barbell rows',
      muscleGroup: MuscleGroup.back,
      equipment: Equipment.barbell,
      difficulty: Difficulty.intermediate,
      trackingType: TrackingType.repsWeight,
      iconName: 'row',
      description:
          'Bent-over bilateral row — the main mass builder for the back.',
      instructions: [
        'Hinge to roughly 45°, keep a neutral spine and braced core.',
        'Row the bar to your lower ribs, elbows past your torso.',
        'Lower under control; do not let the bar yank you out of position.',
      ],
      isBodyweight: false,
      intensityFactor: 1.5,
      defaultRestSeconds: 150,
    ),
    ExerciseSeed(
      slug: 'face-pull',
      name: 'Face pulls',
      muscleGroup: MuscleGroup.back,
      equipment: Equipment.resistanceBand,
      difficulty: Difficulty.beginner,
      trackingType: TrackingType.reps,
      iconName: 'row',
      description:
          'High-rep rear-delt and upper-back work. Excellent shoulder insurance '
          'if you press or push-up often.',
      instructions: [
        'Anchor a band at eye height and hold both ends.',
        'Pull toward your forehead, splitting your hands apart.',
        'Finish with knuckles beside your ears, elbows high.',
      ],
      intensityFactor: 0.6,
      defaultRestSeconds: 60,
    ),

    // ------------------------------------------------------------- shoulders
    ExerciseSeed(
      slug: 'shoulder-press',
      name: 'Shoulder press',
      muscleGroup: MuscleGroup.shoulders,
      equipment: Equipment.dumbbell,
      difficulty: Difficulty.beginner,
      trackingType: TrackingType.repsWeight,
      iconName: 'press',
      description: 'Vertical press for the front and side of the shoulder.',
      instructions: [
        'Start with dumbbells at shoulder height, palms facing forward.',
        'Brace your core so your lower back does not arch.',
        'Press until your arms lock out over your ears.',
        'Lower slowly back to shoulder height.',
      ],
      isBodyweight: false,
      intensityFactor: 1.3,
      defaultRestSeconds: 120,
    ),
    ExerciseSeed(
      slug: 'lateral-raise',
      name: 'Lateral raises',
      muscleGroup: MuscleGroup.shoulders,
      equipment: Equipment.dumbbell,
      difficulty: Difficulty.beginner,
      trackingType: TrackingType.repsWeight,
      iconName: 'raise',
      description:
          'Isolation for the side delts — the muscle that gives shoulders '
          'their width.',
      instructions: [
        'Hold light dumbbells at your sides with a soft elbow bend.',
        'Raise out to shoulder height, leading with the elbows.',
        'Lower under control for three seconds. Do not swing.',
      ],
      isBodyweight: false,
      intensityFactor: 0.7,
      defaultRestSeconds: 60,
    ),
    ExerciseSeed(
      slug: 'pike-pushup',
      name: 'Pike push-ups',
      muscleGroup: MuscleGroup.shoulders,
      equipment: Equipment.none,
      difficulty: Difficulty.intermediate,
      trackingType: TrackingType.reps,
      iconName: 'press',
      description:
          'Bodyweight vertical pressing — the bridge to handstand work.',
      instructions: [
        'From a push-up, walk your feet in and pike your hips up high.',
        'Lower the crown of your head toward the floor between your hands.',
        'Press back up, keeping the hips stacked over the shoulders.',
      ],
      intensityFactor: 1.3,
      defaultRestSeconds: 105,
    ),

    // ------------------------------------------------------------------ arms
    ExerciseSeed(
      slug: 'biceps-curl',
      name: 'Biceps curls',
      muscleGroup: MuscleGroup.arms,
      equipment: Equipment.dumbbell,
      difficulty: Difficulty.beginner,
      trackingType: TrackingType.repsWeight,
      iconName: 'dumbbell',
      description: 'Direct biceps work with a supinated grip.',
      instructions: [
        'Stand tall, dumbbells at your sides, palms forward.',
        'Curl without letting your elbows drift forward.',
        'Squeeze at the top, then lower over three seconds.',
      ],
      isBodyweight: false,
      intensityFactor: 0.8,
      defaultRestSeconds: 75,
    ),
    ExerciseSeed(
      slug: 'hammer-curl',
      name: 'Hammer curls',
      muscleGroup: MuscleGroup.arms,
      equipment: Equipment.dumbbell,
      difficulty: Difficulty.beginner,
      trackingType: TrackingType.repsWeight,
      iconName: 'dumbbell',
      description:
          'Neutral-grip curl that hits the brachialis and forearms alongside '
          'the biceps.',
      instructions: [
        'Hold the dumbbells like hammers, palms facing each other.',
        'Curl straight up, keeping the wrists neutral throughout.',
        'Keep your upper arms still — only the forearms move.',
      ],
      isBodyweight: false,
      intensityFactor: 0.8,
      defaultRestSeconds: 75,
    ),
    ExerciseSeed(
      slug: 'triceps-extension',
      name: 'Triceps extensions',
      muscleGroup: MuscleGroup.arms,
      equipment: Equipment.dumbbell,
      difficulty: Difficulty.beginner,
      trackingType: TrackingType.repsWeight,
      iconName: 'raise',
      description: 'Overhead isolation for the long head of the triceps.',
      instructions: [
        'Hold one dumbbell overhead with both hands.',
        'Lower behind your head by bending only at the elbows.',
        'Keep the elbows pointing forward, not flaring out.',
        'Extend back to lockout without arching your back.',
      ],
      isBodyweight: false,
      intensityFactor: 0.9,
      defaultRestSeconds: 75,
    ),

    // ------------------------------------------------------------------ legs
    ExerciseSeed(
      slug: 'squat',
      name: 'Squats',
      muscleGroup: MuscleGroup.legs,
      equipment: Equipment.none,
      difficulty: Difficulty.beginner,
      trackingType: TrackingType.reps,
      iconName: 'squat',
      description:
          'The fundamental lower-body pattern. Quads, glutes and core.',
      instructions: [
        'Feet shoulder-width, toes turned slightly out.',
        'Sit down and back, keeping your chest proud.',
        'Descend until your hip crease passes your knee, if mobility allows.',
        'Drive through the whole foot to stand.',
      ],
      intensityFactor: 1.0,
      defaultRestSeconds: 90,
    ),
    ExerciseSeed(
      slug: 'lunge',
      name: 'Lunges',
      muscleGroup: MuscleGroup.legs,
      equipment: Equipment.none,
      difficulty: Difficulty.beginner,
      trackingType: TrackingType.reps,
      iconName: 'lunge',
      description:
          'Single-leg work that exposes and fixes left-right imbalances. Count '
          'each leg as one rep.',
      instructions: [
        'Step forward into a long stride.',
        'Drop the back knee toward the floor, torso upright.',
        'Push through the front heel to return to standing.',
        'Alternate legs each rep.',
      ],
      intensityFactor: 1.1,
      defaultRestSeconds: 90,
    ),
    ExerciseSeed(
      slug: 'bulgarian-split-squat',
      name: 'Bulgarian split squats',
      muscleGroup: MuscleGroup.legs,
      equipment: Equipment.bench,
      difficulty: Difficulty.advanced,
      trackingType: TrackingType.reps,
      iconName: 'lunge',
      description:
          'Rear-foot-elevated split squat. Brutal on the quads and glutes with '
          'no equipment beyond a bench.',
      instructions: [
        'Place your rear foot on a bench, front foot a long stride out.',
        'Lower straight down until the back knee nearly touches.',
        'Keep the weight in the front heel; the back leg only balances.',
        'Complete all reps on one side before switching.',
      ],
      intensityFactor: 1.5,
      defaultRestSeconds: 120,
    ),
    ExerciseSeed(
      slug: 'calf-raise',
      name: 'Calf raises',
      muscleGroup: MuscleGroup.legs,
      equipment: Equipment.none,
      difficulty: Difficulty.beginner,
      trackingType: TrackingType.reps,
      iconName: 'calf',
      description: 'High-rep calf work. Responds best to a slow, full range.',
      instructions: [
        'Stand with the balls of your feet on a step, heels hanging.',
        'Rise as high as you can and pause for a second.',
        'Lower until you feel a deep stretch. Do not bounce.',
      ],
      intensityFactor: 0.5,
      defaultRestSeconds: 60,
    ),
    ExerciseSeed(
      slug: 'glute-bridge',
      name: 'Glute bridges',
      muscleGroup: MuscleGroup.legs,
      equipment: Equipment.none,
      difficulty: Difficulty.beginner,
      trackingType: TrackingType.reps,
      iconName: 'bridge',
      description:
          'Hip extension that wakes up the glutes — useful before any leg work.',
      instructions: [
        'Lie on your back, knees bent, feet flat and close to your hips.',
        'Drive through the heels and lift the hips to a straight line.',
        'Squeeze hard at the top for one second, then lower.',
      ],
      intensityFactor: 0.6,
      defaultRestSeconds: 60,
    ),
    ExerciseSeed(
      slug: 'wall-sit',
      name: 'Wall sit',
      muscleGroup: MuscleGroup.legs,
      equipment: Equipment.none,
      difficulty: Difficulty.beginner,
      trackingType: TrackingType.duration,
      iconName: 'wallsit',
      description: 'Isometric quad hold. Simple to scale — just add seconds.',
      instructions: [
        'Slide down a wall until your thighs are parallel to the floor.',
        'Knees stacked over ankles, back flat against the wall.',
        'Breathe steadily and hold.',
      ],
      intensityFactor: 0.8,
      defaultRestSeconds: 90,
    ),

    // ------------------------------------------------------------------ core
    ExerciseSeed(
      slug: 'plank',
      name: 'Plank',
      muscleGroup: MuscleGroup.core,
      equipment: Equipment.none,
      difficulty: Difficulty.beginner,
      trackingType: TrackingType.duration,
      iconName: 'plank',
      description:
          'The reference core hold. Trains the whole trunk to resist extension.',
      instructions: [
        'Elbows under shoulders, forearms flat on the floor.',
        'Squeeze glutes and tuck the ribs down — no sagging hips.',
        'Keep your neck long, eyes on the floor just ahead of your hands.',
        'Stop the set the moment your hips drop.',
      ],
      intensityFactor: 1.0,
      defaultRestSeconds: 90,
    ),
    ExerciseSeed(
      slug: 'side-plank',
      name: 'Side plank',
      muscleGroup: MuscleGroup.core,
      equipment: Equipment.none,
      difficulty: Difficulty.intermediate,
      trackingType: TrackingType.duration,
      iconName: 'plank',
      description:
          'Lateral core hold for the obliques. Time each side separately.',
      instructions: [
        'Elbow under the shoulder, feet stacked or staggered.',
        'Lift the hips so your body is a straight line front-on.',
        'Do not let the top shoulder roll forward.',
      ],
      intensityFactor: 0.9,
      defaultRestSeconds: 60,
    ),
    ExerciseSeed(
      slug: 'situp',
      name: 'Sit-ups',
      muscleGroup: MuscleGroup.core,
      equipment: Equipment.none,
      difficulty: Difficulty.beginner,
      trackingType: TrackingType.reps,
      iconName: 'situp',
      description: 'Full-range trunk flexion from the floor to upright.',
      instructions: [
        'Knees bent, feet flat, hands crossed on your chest.',
        'Curl up one vertebra at a time until your torso is upright.',
        'Lower with the same control — do not drop back down.',
      ],
      intensityFactor: 0.8,
      defaultRestSeconds: 60,
    ),
    ExerciseSeed(
      slug: 'crunch',
      name: 'Crunches',
      muscleGroup: MuscleGroup.core,
      equipment: Equipment.none,
      difficulty: Difficulty.beginner,
      trackingType: TrackingType.reps,
      iconName: 'crunch',
      description:
          'Short-range abdominal flexion. Easier on the hip flexors than sit-ups.',
      instructions: [
        'Lie back with knees bent and hands lightly behind your ears.',
        'Lift only the shoulder blades off the floor.',
        'Exhale at the top, pause, then lower slowly.',
      ],
      intensityFactor: 0.6,
      defaultRestSeconds: 45,
    ),
    ExerciseSeed(
      slug: 'leg-raise',
      name: 'Leg raises',
      muscleGroup: MuscleGroup.core,
      equipment: Equipment.none,
      difficulty: Difficulty.intermediate,
      trackingType: TrackingType.reps,
      iconName: 'legraise',
      description: 'Lower-abdominal work performed lying or hanging.',
      instructions: [
        'Lie flat, hands under your hips for support.',
        'Press your lower back into the floor and keep it there.',
        'Raise straight legs to vertical, then lower without touching down.',
      ],
      intensityFactor: 1.0,
      defaultRestSeconds: 75,
    ),
    ExerciseSeed(
      slug: 'russian-twist',
      name: 'Russian twists',
      muscleGroup: MuscleGroup.core,
      equipment: Equipment.none,
      difficulty: Difficulty.beginner,
      trackingType: TrackingType.reps,
      iconName: 'twist',
      description:
          'Rotational core work. Count one rep each time you return to centre.',
      instructions: [
        'Sit with knees bent, lean back to about 45°.',
        'Rotate your ribs — not just your arms — from side to side.',
        'Keep the chest tall; do not round the lower back.',
      ],
      intensityFactor: 0.7,
      defaultRestSeconds: 60,
    ),
    ExerciseSeed(
      slug: 'mountain-climber',
      name: 'Mountain climbers',
      muscleGroup: MuscleGroup.core,
      equipment: Equipment.none,
      difficulty: Difficulty.beginner,
      trackingType: TrackingType.reps,
      iconName: 'climber',
      description: 'Fast alternating knee drives from a push-up position.',
      instructions: [
        'Start in a strong plank with hands under shoulders.',
        'Drive one knee toward your chest, then switch.',
        'Keep the hips level — no bouncing up and down.',
      ],
      intensityFactor: 0.8,
      defaultRestSeconds: 60,
    ),

    // ------------------------------------------------------- full body / cardio
    ExerciseSeed(
      slug: 'burpee',
      name: 'Burpees',
      muscleGroup: MuscleGroup.fullBody,
      equipment: Equipment.none,
      difficulty: Difficulty.intermediate,
      trackingType: TrackingType.reps,
      iconName: 'burpee',
      description:
          'Squat, plank, push-up, jump. The most conditioning per square metre '
          'of floor.',
      instructions: [
        'Drop to your hands and kick the feet back to a plank.',
        'Perform a push-up, then jump the feet back in.',
        'Finish standing with a jump and a clap overhead.',
      ],
      intensityFactor: 1.6,
      defaultRestSeconds: 90,
    ),
    ExerciseSeed(
      slug: 'jumping-jack',
      name: 'Jumping jacks',
      muscleGroup: MuscleGroup.cardio,
      equipment: Equipment.none,
      difficulty: Difficulty.beginner,
      trackingType: TrackingType.reps,
      iconName: 'jump',
      description: 'Low-skill warm-up that raises the heart rate quickly.',
      instructions: [
        'Jump the feet wide while raising your arms overhead.',
        'Jump back to the start. Land softly through the whole foot.',
      ],
      intensityFactor: 0.4,
      defaultRestSeconds: 45,
    ),
    ExerciseSeed(
      slug: 'run',
      name: 'Running',
      muscleGroup: MuscleGroup.cardio,
      equipment: Equipment.none,
      difficulty: Difficulty.beginner,
      trackingType: TrackingType.distanceDuration,
      iconName: 'run',
      description: 'Logged by distance and time, indoors or out.',
      instructions: [
        'Warm up with five easy minutes before picking up the pace.',
        'Aim for a cadence you can hold, not a pace you can survive.',
        'Log the total distance and time when you finish.',
      ],
      intensityFactor: 1.0,
      defaultRestSeconds: 0,
    ),
    ExerciseSeed(
      slug: 'jump-rope',
      name: 'Jump rope',
      muscleGroup: MuscleGroup.cardio,
      equipment: Equipment.none,
      difficulty: Difficulty.beginner,
      trackingType: TrackingType.duration,
      iconName: 'rope',
      description:
          'Timed skipping. Great low-space conditioning and calf work.',
      instructions: [
        'Elbows close to the ribs, turn the rope with the wrists.',
        'Stay on the balls of your feet with small, quiet hops.',
        'Break long sets into intervals if your calves fatigue.',
      ],
      intensityFactor: 0.9,
      defaultRestSeconds: 60,
    ),
  ];

  /// Slugs offered as the default "quick start" set for new users.
  static const List<String> starterFavourites = [
    'pushup',
    'plank',
    'squat',
    'situp',
  ];
}
