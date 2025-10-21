import '../models/meal.dart';
import '../models/exercise.dart';

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
}
