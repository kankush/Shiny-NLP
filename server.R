shinyServer(function(input, output) {
#Reading The input file
  D1 <- reactive({
    if (is.null(input$new)) {return(NULL) } 
    else{
      Data <- readLines(input$new$datapath)
      return(Data)
    }
  })
#Loading Model file
  model = reactive({
    model = udpipe_load_model("english-ewt-ud-2.3-181115.udpipe")
    return(model)
  })
#  
  annotate = reactive({
    a <- udpipe_annotate(model(),x = D1())
    a <- select(as.data.frame(a),-sentence)
    head(a,100)
  })
  
  annotate1=reactive({
    b <- udpipe_annotate(model(),x = D1())
    b <- select(as.data.frame(b),-sentence)
    return(b)
  })
  
#download output file  
  output$downloadfile <- downloadHandler(
    file = function(){
      "data.csv"
    },
    content = function(new){
      write.csv(annotate1(),new,row.names = FALSE)
    }
  )
#render the annotated table
  output$table = renderDataTable({
      out = annotate()
      return(out)
  })
#wordcloud-noun
  output$Nouns = renderPlot({
    if(is.null(input$new)){return(NULL)}
    else{
      all_nouns = annotate1() %>% subset(., upos %in% "NOUN") 
      top_nouns = txt_freq(all_nouns$lemma)  # txt_freq() calcs noun freqs in desc order
      
      wordcloud(top_nouns$key,top_nouns$freq, min.freq = 3,colors = 1:10 )
    }
  })
#wordcloud-Verb  
  output$Verbs = renderPlot({
    if(is.null(input$new)){return(NULL)}
    else{
      all_verbs = annotate1() %>% subset(., upos %in% "VERB") 
      top_verbs = txt_freq(all_verbs$lemma)
      
      wordcloud(top_verbs$key,top_verbs$freq, min.freq = 3,colors = 1:10 )
    }
  })
#co-occurence
  output$coplot = renderPlot({
    if(is.null(input$new)){return(NULL)}
    else{
      occ <- cooccurrence(x = subset(annotate(), upos %in% input$upos),
        term = "lemma",
        group = c("doc_id", "paragraph_id", "sentence_id"))
      
      network <- head(occ, 50)
      network <- igraph::graph_from_data_frame(network)
      
      ggraph(network, layout = "fr") +  
        
        geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "blue") +  
        geom_node_text(aes(label = name), col = "darkgreen", size = 5) +
        
        theme_graph(base_family = "Arial Narrow") +  
        theme(legend.position = "none") +
        
        labs(title = "3 word distance cooccurences", subtitle = "Select check boxes in Upos")
    }
  })
})
