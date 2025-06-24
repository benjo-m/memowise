import { Deck } from '@/models/deck';
import React, { useEffect, useState } from 'react';
import { ActivityIndicator, FlatList, Text, View } from "react-native";

export default function DecksScreen() {
    const [isLoading, setLoading] = useState(true);
    const [data, setData] = useState<Deck[]>([]);

    const getDecks = async () => {
        try {
            const response = await fetch('http://localhost:3000/decks');
            const json = await response.json();
            setData(json);
        } catch (error) {
            console.error(error);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        getDecks();
    }, []);

    return (
        <View style={{ flex: 1, padding: 24 }}>
            {isLoading ? (
                <ActivityIndicator />
            ) : (
                <FlatList
                    data={data}
                    keyExtractor={({ id }) => id}
                    renderItem={({ item }) => (
                        <Text>
                            {item.id} {item.name}
                        </Text>
                    )}
                />
            )}
        </View>
    );
}