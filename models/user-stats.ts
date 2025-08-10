type StudySessionsByPartOfDay = {
  morning: number;
  afternoon: number;
  evening: number;
  night: number;
};

type StudySessionsByWeekday = {
  Sunday: number;
  Monday: number;
  Tuesday: number;
  Wednesday: number;
  Thursday: number;
  Friday: number;
  Saturday: number;
};

type FavoriteDeck = {
  deck: string;
  count: number;
} | null;

export type UserStats = {
  longest_study_streak: number;
  current_study_streak: number;
  total_study_sessions: number;
  total_time_spent_studying: number;
  average_session_duration: number;
  study_sessions_by_part_of_day: StudySessionsByPartOfDay;
  study_sessions_by_weekday: StudySessionsByWeekday;
  average_flashcards_reviewed_per_session: number;
  total_correct_answers: number;
  total_incorrect_answers: number;
  favorite_deck: FavoriteDeck;
};
