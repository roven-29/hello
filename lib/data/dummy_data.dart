import '../models/meal.dart';
import '../models/exercise.dart';
import '../models/workout.dart';

class DummyData {
  static List<DietCategory> getDietCategories() {
    return [
      DietCategory(
        id: 'weight_loss',
        name: 'Weight Loss',
        icon: '🍎',
        description: 'Low-calorie meals for healthy weight reduction',
        meals: [
          Meal(
            id: '1',
            name: 'Oats & Fruits Bowl',
            image: 'assets/images/meal1.jpg',
            calories: 350,
            ingredients: ['Oats', 'Banana', 'Blueberries', 'Almonds', 'Honey'],
            nutrition: {'protein': 12.0, 'carbs': 45.0, 'fats': 8.0},
            preparationTips: 'Mix oats with milk, top with fruits and nuts. Add honey for sweetness.',
            category: 'weight_loss',
          ),
          Meal(
            id: '2',
            name: 'Grilled Chicken Salad',
            image: 'assets/images/meal2.jpg',
            calories: 280,
            ingredients: ['Chicken Breast', 'Mixed Greens', 'Cherry Tomatoes', 'Cucumber', 'Olive Oil'],
            nutrition: {'protein': 25.0, 'carbs': 8.0, 'fats': 12.0},
            preparationTips: 'Grill chicken, chop vegetables, mix with olive oil dressing.',
            category: 'weight_loss',
          ),
        ],
      ),
      DietCategory(
        id: 'muscle_gain',
        name: 'Muscle Gain',
        icon: '💪',
        description: 'High-protein meals for muscle building',
        meals: [
          Meal(
            id: '3',
            name: 'Protein Power Bowl',
            image: 'assets/images/meal3.jpg',
            calories: 520,
            ingredients: ['Quinoa', 'Salmon', 'Broccoli', 'Sweet Potato', 'Avocado'],
            nutrition: {'protein': 35.0, 'carbs': 40.0, 'fats': 18.0},
            preparationTips: 'Cook quinoa, bake salmon and sweet potato, steam broccoli.',
            category: 'muscle_gain',
          ),
          Meal(
            id: '4',
            name: 'Greek Yogurt Parfait',
            image: 'assets/images/meal4.jpg',
            calories: 380,
            ingredients: ['Greek Yogurt', 'Protein Powder', 'Granola', 'Berries', 'Chia Seeds'],
            nutrition: {'protein': 28.0, 'carbs': 35.0, 'fats': 12.0},
            preparationTips: 'Mix protein powder with yogurt, layer with granola and berries.',
            category: 'muscle_gain',
          ),
        ],
      ),
      DietCategory(
        id: 'balanced',
        name: 'Balanced Diet',
        icon: '⚖️',
        description: 'Well-rounded meals for overall health',
        meals: [
          Meal(
            id: '5',
            name: 'Mediterranean Bowl',
            image: 'assets/images/meal5.jpg',
            calories: 450,
            ingredients: ['Brown Rice', 'Chickpeas', 'Feta Cheese', 'Olives', 'Bell Peppers'],
            nutrition: {'protein': 18.0, 'carbs': 55.0, 'fats': 15.0},
            preparationTips: 'Cook brown rice, roast vegetables, mix with chickpeas and feta.',
            category: 'balanced',
          ),
        ],
      ),
      DietCategory(
        id: 'vegan',
        name: 'Vegan',
        icon: '🌱',
        description: 'Plant-based nutritious meals',
        meals: [
          Meal(
            id: '6',
            name: 'Veggie Buddha Bowl',
            image: 'assets/images/meal6.jpg',
            calories: 420,
            ingredients: ['Kale', 'Chickpeas', 'Tahini', 'Carrots', 'Quinoa'],
            nutrition: {'protein': 16.0, 'carbs': 48.0, 'fats': 14.0},
            preparationTips: 'Massage kale, roast chickpeas, prepare tahini dressing.',
            category: 'vegan',
          ),
        ],
      ),
    ];
  }

  static List<WorkoutCategory> getWorkoutCategories() {
    return [
      WorkoutCategory(
        id: 'upper_body',
        name: 'Upper Body',
        icon: '💪',
        description: 'Strengthen your arms, chest, and back',
        exercises: [
          Exercise(
            id: '1',
            name: 'Push-ups',
            description: 'Classic upper body exercise',
            image: 'assets/images/pushup.jpg',
            duration: 30,
            instructions: 'Keep your back straight, lower chest to ground, push back up.',
            category: 'upper_body',
          ),
          Exercise(
            id: '2',
            name: 'Pull-ups',
            description: 'Build back and arm strength',
            image: 'assets/images/pullup.jpg',
            duration: 45,
            instructions: 'Hang from bar, pull body up until chin over bar, lower slowly.',
            category: 'upper_body',
          ),
        ],
      ),
      WorkoutCategory(
        id: 'lower_body',
        name: 'Lower Body',
        icon: '🦵',
        description: 'Target your legs and glutes',
        exercises: [
          Exercise(
            id: '3',
            name: 'Squats',
            description: 'Fundamental leg exercise',
            image: 'assets/images/squat.jpg',
            duration: 30,
            instructions: 'Stand with feet shoulder-width apart, lower as if sitting, rise up.',
            category: 'lower_body',
          ),
          Exercise(
            id: '4',
            name: 'Lunges',
            description: 'Single-leg strength builder',
            image: 'assets/images/lunge.jpg',
            duration: 40,
            instructions: 'Step forward, lower back knee toward ground, push back up.',
            category: 'lower_body',
          ),
        ],
      ),
      WorkoutCategory(
        id: 'abs',
        name: 'Abs',
        icon: '🔥',
        description: 'Core strengthening exercises',
        exercises: [
          Exercise(
            id: '5',
            name: 'Plank',
            description: 'Core stability exercise',
            image: 'assets/images/plank.jpg',
            duration: 60,
            instructions: 'Hold straight line from head to heels, engage core muscles.',
            category: 'abs',
          ),
          Exercise(
            id: '6',
            name: 'Crunches',
            description: 'Traditional ab exercise',
            image: 'assets/images/crunch.jpg',
            duration: 30,
            instructions: 'Lie on back, lift shoulders off ground, lower slowly.',
            category: 'abs',
          ),
        ],
      ),
      WorkoutCategory(
        id: 'full_body',
        name: 'Full Body',
        icon: '🏃',
        description: 'Complete body workout',
        exercises: [
          Exercise(
            id: '7',
            name: 'Burpees',
            description: 'High-intensity full body exercise',
            image: 'assets/images/burpee.jpg',
            duration: 45,
            instructions: 'Squat, jump back to plank, do push-up, jump forward, jump up.',
            category: 'full_body',
          ),
          Exercise(
            id: '8',
            name: 'Mountain Climbers',
            description: 'Cardio and core exercise',
            image: 'assets/images/mountain_climber.jpg',
            duration: 30,
            instructions: 'Start in plank, alternate bringing knees to chest quickly.',
            category: 'full_body',
          ),
        ],
      ),
      WorkoutCategory(
        id: 'fat_loss',
        name: 'Fat Loss',
        icon: '⚡',
        description: 'High-intensity fat burning',
        exercises: [
          Exercise(
            id: '9',
            name: 'Jumping Jacks',
            description: 'Simple cardio exercise',
            image: 'assets/images/jumping_jacks.jpg',
            duration: 30,
            instructions: 'Jump feet apart while raising arms overhead, return to start.',
            category: 'fat_loss',
          ),
          Exercise(
            id: '10',
            name: 'High Knees',
            description: 'Running in place',
            image: 'assets/images/high_knees.jpg',
            duration: 30,
            instructions: 'Run in place, bringing knees up to hip level.',
            category: 'fat_loss',
          ),
        ],
      ),
    ];
  }

  // Get 20-minute workout routines
  static List<Workout> getWorkouts() {
    return [
      // Strength Training
      Workout(
        id: 'strength_training',
        name: 'Strength Training',
        description: 'Build muscle and strength with resistance exercises',
        icon: '💪',
        totalDuration: 1200,
        exercises: [
          WorkoutExercise(name: 'Push-ups', duration: 45, instructions: 'Lower your chest to the ground, push back up'),
          WorkoutExercise(name: 'Squats', duration: 45, instructions: 'Lower as if sitting, rise up with power'),
          WorkoutExercise(name: 'Diamond Push-ups', duration: 45, instructions: 'Form diamond with hands, push up'),
          WorkoutExercise(name: 'Lunges', duration: 45, instructions: 'Step forward, lower back knee, switch legs'),
          WorkoutExercise(name: 'Rest', duration: 30, instructions: 'Take a break and hydrate', isRest: true),
          WorkoutExercise(name: 'Pike Push-ups', duration: 45, instructions: 'Hands on floor, inverted V, push head down'),
          WorkoutExercise(name: 'Jump Squats', duration: 45, instructions: 'Squat down, jump up explosively'),
          WorkoutExercise(name: 'Wide Push-ups', duration: 45, instructions: 'Hands wider than shoulders, push up'),
          WorkoutExercise(name: 'Side Lunges', duration: 45, instructions: 'Step to side, lower into lunge'),
          WorkoutExercise(name: 'Rest', duration: 30, instructions: 'Take a break and hydrate', isRest: true),
          WorkoutExercise(name: 'Decline Push-ups', duration: 45, instructions: 'Feet elevated, push up with extra resistance'),
          WorkoutExercise(name: 'Sumo Squats', duration: 45, instructions: 'Feet wide, toes out, lower deep'),
          WorkoutExercise(name: 'Archer Push-ups', duration: 45, instructions: 'Push to one side, alternate'),
          WorkoutExercise(name: 'Jumping Lunges', duration: 45, instructions: 'Switch legs in air'),
        ],
      ),
      // Cardio Workouts
      Workout(
        id: 'cardio_workouts',
        name: 'Cardio Workouts',
        description: 'High-intensity cardio to boost endurance',
        icon: '❤️',
        totalDuration: 1200,
        exercises: [
          WorkoutExercise(name: 'Jumping Jacks', duration: 45, instructions: 'Jump feet apart while raising arms'),
          WorkoutExercise(name: 'High Knees', duration: 45, instructions: 'Run in place, knees to chest'),
          WorkoutExercise(name: 'Burpees', duration: 45, instructions: 'Squat, plank, push-up, jump up'),
          WorkoutExercise(name: 'Mountain Climbers', duration: 45, instructions: 'Alternate knees to chest quickly'),
          WorkoutExercise(name: 'Rest', duration: 30, instructions: 'Take a break and hydrate', isRest: true),
          WorkoutExercise(name: 'Butt Kicks', duration: 45, instructions: 'Jog in place, kick heels to glutes'),
          WorkoutExercise(name: 'Star Jumps', duration: 45, instructions: 'Jump up with arms and legs spread'),
          WorkoutExercise(name: 'Sprint in Place', duration: 45, instructions: 'Run as fast as possible in place'),
          WorkoutExercise(name: 'Inchworms', duration: 45, instructions: 'Touch toes, walk hands out, walk feet in'),
          WorkoutExercise(name: 'Rest', duration: 30, instructions: 'Take a break and hydrate', isRest: true),
          WorkoutExercise(name: 'Skaters', duration: 45, instructions: 'Leap side to side like speed skater'),
          WorkoutExercise(name: 'Jump Squats', duration: 45, instructions: 'Squat then jump up explosively'),
          WorkoutExercise(name: 'Frog Jumps', duration: 45, instructions: 'Deep squat, jump forward like a frog'),
          WorkoutExercise(name: 'Speed Skaters', duration: 45, instructions: 'Quick side leaps with arm swings'),
        ],
      ),
      // Home Workouts
      Workout(
        id: 'home_workouts',
        name: 'Home Workouts',
        description: 'Equipment-free exercises you can do anywhere',
        icon: '🏠',
        totalDuration: 1200,
        exercises: [
          WorkoutExercise(name: 'Bodyweight Squats', duration: 60, instructions: 'Classic squats, no equipment needed'),
          WorkoutExercise(name: 'Push-ups', duration: 45, instructions: 'Standard push-ups on floor'),
          WorkoutExercise(name: 'Lunges', duration: 60, instructions: 'Alternate legs, no weights needed'),
          WorkoutExercise(name: 'Plank Hold', duration: 45, instructions: 'Hold straight line from head to heels'),
          WorkoutExercise(name: 'Rest', duration: 30, instructions: 'Take a break', isRest: true),
          WorkoutExercise(name: 'Glute Bridges', duration: 60, instructions: 'Lie down, lift hips, squeeze glutes'),
          WorkoutExercise(name: 'Dips', duration: 45, instructions: 'Use chair or floor, lower and raise body'),
          WorkoutExercise(name: 'Wall Sit', duration: 60, instructions: 'Lean against wall, sit position'),
          WorkoutExercise(name: 'Calf Raises', duration: 45, instructions: 'Stand on toes, lower and rise'),
          WorkoutExercise(name: 'Rest', duration: 30, instructions: 'Take a break', isRest: true),
          WorkoutExercise(name: 'Flutter Kicks', duration: 45, instructions: 'Lie on back, alternate leg kicks'),
          WorkoutExercise(name: 'Shadow Boxing', duration: 45, instructions: 'Punch the air, fast and furious'),
          WorkoutExercise(name: 'Side Plank', duration: 45, instructions: 'Hold plank on each side'),
          WorkoutExercise(name: 'Reverse Lunges', duration: 45, instructions: 'Step back into lunge position'),
        ],
      ),
      // Yoga Exercises
      Workout(
        id: 'yoga_exercises',
        name: 'Yoga Exercises',
        description: 'Gentle stretches and poses for flexibility',
        icon: '🧘',
        totalDuration: 1200,
        exercises: [
          WorkoutExercise(name: 'Mountain Pose', duration: 30, instructions: 'Stand tall, feet together, arms at sides'),
          WorkoutExercise(name: 'Downward Dog', duration: 45, instructions: 'Hands and feet on floor, form inverted V'),
          WorkoutExercise(name: 'Warrior I', duration: 45, instructions: 'Lunge forward, arms up, hold'),
          WorkoutExercise(name: 'Warrior II', duration: 45, instructions: 'Turn to side, arms out, deep lunge'),
          WorkoutExercise(name: 'Child\'s Pose', duration: 30, instructions: 'Kneel, sit back on heels, relax', isRest: true),
          WorkoutExercise(name: 'Cat-Cow Stretch', duration: 45, instructions: 'Arch and round back slowly'),
          WorkoutExercise(name: 'Cobra Pose', duration: 45, instructions: 'Lie on stomach, lift chest, look up'),
          WorkoutExercise(name: 'Triangle Pose', duration: 45, instructions: 'Legs wide, reach forward and up'),
          WorkoutExercise(name: 'Pigeon Pose', duration: 60, instructions: 'Hip opener stretch on each side'),
          WorkoutExercise(name: 'Rest', duration: 30, instructions: 'Savasana - relax completely', isRest: true),
          WorkoutExercise(name: 'Tree Pose', duration: 45, instructions: 'Balance on one leg, hands in prayer'),
          WorkoutExercise(name: 'Bridge Pose', duration: 45, instructions: 'Lift hips, clasp hands under back'),
          WorkoutExercise(name: 'Seated Forward Bend', duration: 45, instructions: 'Sit, reach forward to toes'),
          WorkoutExercise(name: 'Final Savasana', duration: 60, instructions: 'Lie down, relax completely', isRest: true),
        ],
      ),
    ];
  }

  static Workout? getWorkoutById(String id) {
    return getWorkouts().firstWhere(
      (workout) => workout.id == id,
      orElse: () => throw Exception('Workout not found'),
    );
  }
}
