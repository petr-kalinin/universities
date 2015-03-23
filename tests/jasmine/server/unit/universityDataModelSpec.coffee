describe "University", ->
    it "should be created with name", ->
        spyOn UniversitiesCollection, "insert"
            .and.returnValue true

        UniversitiesCollection.create "University 1"
 
        expect(Universities.insert).toHaveBeenCalledWith
            name: "University 1"
                
    it "should be able to delete a university without comments", (done) ->
        spyOn UniversitiesCollection, "remove" 
            .and.returnValue true
        spyOn CommentsCollection, "findOne"
            .and.returnValue null
        
        univ = UniversitiesCollection._transform name: "Test", _id: "000"
        expect(univ).toBeDefined()
        univ.remove (error, result) ->
            expect(error).toBeNull()
            expect(CommentsCollection.findOne).toHaveBeenCalledWith university: "000"
            expect(UniversitiesCollection.remove).toHaveBeenCalledWith id: "000"
            done()
        
    it "should not be able to delete a university with comments", (done) ->
        spyOn UniversitiesCollection, "remove" 
            .and.returnValue true
        spyOn CommentsCollection, "findOne"
            .and.returnValue 1
        
        univ = UniversitiesCollection._transform name: "Test", _id: "000"
        expect(univ).toBeDefined()
        univ.remove (error, result) ->
            expect(error.error).toBe("cant-delete")
            expect(CommentsCollection.findOne).toHaveBeenCalledWith university: "000"
            expect(UniversitiesCollection.remove).not.toHaveBeenCalled
            done()
        
