describe "Category", ->
    it "should be created with name and parent", ->
        spyOn CategoriesCollection, "insert"
            .and.returnValue true

        CategoriesCollection.create "Category 1", "foo"
 
        expect(Categories.insert).toHaveBeenCalledWith
            name: "Category 1",
            parent: "foo"
