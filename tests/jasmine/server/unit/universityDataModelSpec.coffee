describe "University", ->
    it "should be created with name", ->
        spyOn UniversitiesCollection, "insert"
            .and.returnValue true

        UniversitiesCollection.create "University 1"
 
        expect(Universities.insert).toHaveBeenCalledWith
            name: "University 1"
                
    it "should be able to delete a university without comments", ->
        spyOn UniversitiesCollection, "remove" 
            .and.returnValue true
        spyOn CommentsCollection, "findOne"
            .and.returnValue null
        
        univ = UniversitiesCollection._transform name: "Test", _id: "000"
        expect(univ).toBeDefined()
        expect(univ.canDelete()).toBe(true)
        univ.remove() 
        expect(CommentsCollection.findOne).toHaveBeenCalledWith university: "000"
        expect(UniversitiesCollection.remove).toHaveBeenCalledWith id: "000"
        
    it "should not be able to delete a university with comments", ->
        spyOn UniversitiesCollection, "remove" 
            .and.returnValue true
        spyOn CommentsCollection, "findOne"
            .and.returnValue "foo"
        
        univ = UniversitiesCollection._transform name: "Test", _id: "000"
        expect(univ).toBeDefined()
        expect(univ.canDelete()).toBe(false)
        try
            univ.remove()
        catch error
            expect(error.error).toBe("cant-delete")
        expect(univ.remove).toThrow();
        expect(CommentsCollection.findOne).toHaveBeenCalledWith university: "000"
        expect(UniversitiesCollection.remove).not.toHaveBeenCalled
        
