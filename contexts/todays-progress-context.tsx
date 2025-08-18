import { createContext, useContext, useState } from "react";

type TodaysProgressContextType = {
  flashcardsDueTodayCount: number;
  flashcardsReviewedTodayCount: number;
  progressDate: Date;
  setFlashcardsDueTodayCount: React.Dispatch<React.SetStateAction<number>>;
  setFlashcardsReviewedTodayCount: React.Dispatch<React.SetStateAction<number>>;
  setProgressDate: React.Dispatch<React.SetStateAction<Date>>;
};

const TodaysProgressContext = createContext<TodaysProgressContextType | null>(null);

export const useTodaysProgress = () => {
  const ctx = useContext(TodaysProgressContext);
  if (!ctx) throw new Error("useTodaysProgress must be used within a TodaysProgressProvider");
  return ctx;
};

export const TodaysProgressProvider = ({ children }: { children: React.ReactNode }) => {
  const [flashcardsDueTodayCount, setFlashcardsDueTodayCount] = useState(0);
  const [flashcardsReviewedTodayCount, setFlashcardsReviewedTodayCount] = useState(0);
  const [progressDate, setProgressDate] = useState(new Date());

  return (
    <TodaysProgressContext.Provider
      value={{
        flashcardsDueTodayCount,
        flashcardsReviewedTodayCount,
        progressDate,
        setFlashcardsDueTodayCount,
        setFlashcardsReviewedTodayCount,
        setProgressDate,
      }}
    >
      {children}
    </TodaysProgressContext.Provider>
  );
};
