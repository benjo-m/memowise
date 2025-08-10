import { getUserStats } from "@/api/users";
import { useFocusEffect } from "@react-navigation/native";
import React, { useCallback, useState } from "react";
import { ActivityIndicator, ScrollView, Text, View } from "react-native";
import type { UserStats } from "../../../models/user-stats";

export default function StatsScreen() {
  const [stats, setStats] = useState<UserStats | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useFocusEffect(
    useCallback(() => {
      setLoading(true);
      setError(null);

      getUserStats()
        .then((data) => setStats(data))
        .catch(() => setError("Failed to load stats"))
        .finally(() => setLoading(false));
    }, [])
  );

  if (loading) {
    return (
      <View style={{ flex: 1, justifyContent: "center", alignItems: "center" }}>
        <ActivityIndicator />
      </View>
    );
  }

  if (error) {
    return (
      <View style={{ flex: 1, justifyContent: "center", alignItems: "center" }}>
        <Text style={{ color: "red" }}>{error}</Text>
      </View>
    );
  }

  if (!stats) return null;

  return (
    <ScrollView contentContainerStyle={{ padding: 20 }}>
      <Text>Longest study streak: {stats.longest_study_streak}</Text>
      <Text>Current study streak: {stats.current_study_streak}</Text>
      <Text>Total study sessions: {stats.total_study_sessions}</Text>
      <Text>Total time spent studying (seconds): {stats.total_time_spent_studying}</Text>
      <Text>Average session duration (seconds): {stats.average_session_duration.toFixed(1)}</Text>

      <Text style={{ marginTop: 10, fontWeight: "bold" }}>Sessions by part of day:</Text>
      <Text>Morning: {stats.study_sessions_by_part_of_day.morning}</Text>
      <Text>Afternoon: {stats.study_sessions_by_part_of_day.afternoon}</Text>
      <Text>Evening: {stats.study_sessions_by_part_of_day.evening}</Text>
      <Text>Night: {stats.study_sessions_by_part_of_day.night}</Text>

      <Text style={{ marginTop: 10, fontWeight: "bold" }}>Sessions by weekday:</Text>
      <Text>Sunday: {stats.study_sessions_by_weekday.Sunday}</Text>
      <Text>Monday: {stats.study_sessions_by_weekday.Monday}</Text>
      <Text>Tuesday: {stats.study_sessions_by_weekday.Tuesday}</Text>
      <Text>Wednesday: {stats.study_sessions_by_weekday.Wednesday}</Text>
      <Text>Thursday: {stats.study_sessions_by_weekday.Thursday}</Text>
      <Text>Friday: {stats.study_sessions_by_weekday.Friday}</Text>
      <Text>Saturday: {stats.study_sessions_by_weekday.Saturday}</Text>

      <Text style={{ marginTop: 10 }}>
        Average flashcards reviewed per session:{" "}
        {stats.average_flashcards_reviewed_per_session.toFixed(1)}
      </Text>
      <Text>Total correct answers: {stats.total_correct_answers}</Text>
      <Text>Total incorrect answers: {stats.total_incorrect_answers}</Text>

      <Text style={{ marginTop: 10, fontWeight: "bold" }}>Favorite deck:</Text>
      {stats.favorite_deck ? (
        <>
          <Text>Name: {stats.favorite_deck.deck}</Text>
          <Text>Count: {stats.favorite_deck.count}</Text>
        </>
      ) : (
        <Text>No favorite deck data</Text>
      )}
    </ScrollView>
  );
}
