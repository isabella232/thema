package exemplars

import "github.com/grafana/thema"

defaultchange: {
    description: "The default value for a field is changed, entailing a new sequence."
    l: thema.#Lineage & {
        Seqs: [
            {
                schemas: [
                    {
                        aunion: *"foo" | "bar" | "baz"
                    }
                ]
            },
            {
                schemas: [
                    {
                        aunion: "foo" | *"bar" | "baz"
                    }
                ]

                lens: forward: {
                    to: Seqs[1].schemas[0]
                    from: Seqs[0].schemas[0]
                    translated: to & rel
                    rel: {
                        // FIXME lenses need more structure to allow disambiguating absence and presence in the instance
                        if from.aunion == "foo" {
                            aunion: "bar"
                        }
                        if from.aunion != "foo" {
                            aunion: from.anion
                        }
                    }
                    lacunae: [
                        // FIXME really feels like these lacunae should be able to be autogenerated, at least for simple cases?
                        if from.aunion == "foo" {
                            thema.#Lacuna & {
                                sourceFields: [{
                                    path: "aunion"
                                    value: from.aunion
                                }]
                                targetFields: [{
                                    path: "aunion"
                                    value: to.aunion
                                }]
                            }
                            message: "aunion was the source default, \"foo\", and was changed to the target default, \"bar\""
                            type: thema.#LacunaTypes.ChangedDefault
                        }
                    ]
                }
                lens: reverse: {
                    to: Seqs[0].schemas[0]
                    from: Seqs[1].schemas[0]
                    translated: to & rel
                    rel: {
                        if from.aunion == "bar" {
                            aunion: "foo"
                        }
                        if from.aunion != "bar" {
                            aunion: from.anion
                        }
                    }
                    lacunae: [
                        if from.aunion == "foo" {
                            thema.#Lacuna & {
                                sourceFields: [{
                                    path: "aunion"
                                    value: from.aunion
                                }]
                                targetFields: [{
                                    path: "aunion"
                                    value: to.aunion
                                }]
                            }
                            message: "aunion was the source default, \"bar\", and was changed to the target default, \"foo\""
                            type: thema.#LacunaTypes.ChangedDefault
                        }
                    ]
                }
            }
        ]
    }
}