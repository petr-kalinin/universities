describe "University", ->
    it "should be created with name", ->
        spyOn(UniversitiesCollection, "insert")
            .and.callFake (name) ->
                true

        UniversitiesCollection.create "University 1"
 
        expect(Universities.insert).toHaveBeenCalledWith
            name: "University 1"
