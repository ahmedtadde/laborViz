shinyServer(function(input, output) {
    
    # =========================================================================
    # Reactive resources
    # =========================================================================
    resource.trend <- reactive({
      return(
        dataframes$trend[
        population == input$trend_population &
        year >= input$trend_years[1] &
        year <= input$trend_years[2]]
      )
    })

    resource.occupation <- reactive({
      
      return(dataframes$occupation[
        age_group %in% input$occupation_age_group &
        race %in% input$occupation_race &
        occupation %in% input$occupation_occupation
      ])
    })

    resource.education <- reactive({
      if (input$education_category == "Gender") {
        df <- dataframes$education[category %in% c("Men", "Women")]
      }
    
      if (input$education_category == "Race") {
        df <- dataframes$education[category %in% c("White", "Black", "Asian", "Hispanic")]
      }
    
      return(df[metric == input$education_metric & education %in% input$education_education])
    })



    # =========================================================================
    # Server outputs : Datatables
    # =========================================================================
    output$trend_datatable <- DT::renderDataTable({
      datatable(
        copy(resource.trend())[,population:=NULL],
        filter = 'top',
        rownames = FALSE,
        selection="multiple", 
        escape=FALSE,
        extensions = c(
          'Buttons',
          'Responsive'
        ),
        
        options = list(
          dom = 'Blrtip',
          autoWidth = TRUE,
          buttons = list('excel', 'csv'),
          Responsive = TRUE,
          lengthMenu = list(c(10, 20, 50, 100), c('10', '20','50','100'))
        )
      )
    })

    output$occupation_datatable <- DT::renderDataTable({
      datatable(
        resource.occupation(),
        filter = 'top',
        rownames = FALSE,
        selection="multiple", 
        escape=FALSE,
        extensions = c(
          'Buttons',
          'Responsive'
        ),
        
        options = list(
          dom = 'Blrtip',
          autoWidth = TRUE,
          buttons = list('excel', 'csv'),
          Responsive = TRUE,
          lengthMenu = list(c(10, 20, 50, 100), c('10', '20','50','100'))
        )
      )
    })

    output$education_datatable <- DT::renderDataTable({
      datatable(
        copy(resource.education())[,metric:=NULL],
        filter = 'top',
        rownames = FALSE,
        selection="multiple", 
        escape=FALSE,
        extensions = c(
          'Buttons',
          'Responsive'
        ),
        
        options = list(
          dom = 'Blrtip',
          autoWidth = TRUE,
          buttons = list('excel', 'csv'),
          Responsive = TRUE,
          lengthMenu = list(c(10, 20, 50, 100), c('10', '20','50','100'))
        )
      )
    })



    # =========================================================================
    # Server outputs : Plots
    # =========================================================================
    output$trend_barchart <- renderPlot({
        # get data from dataframe
        df <- copy(resource.trend())[, year:= as.numeric(year)]
        df_men <- df[gender %in% "Men"]
        df_women <- df[gender %in% "Women"]
        population <- input$trend_population

        # plotting
        plot <- ggplot(df, aes(x=year, y=value, group=gender, fill=gender)) +
            geom_bar(data=df_men, aes(y=value), stat="identity", color="black") +
            geom_text(data=df_men, aes(y=value, label=value, color=gender), angle=90, size=3.5, fontface="italic", hjust=-0.25) +
            geom_bar(data=df_women, aes(y=-value), stat="identity", color="black") +
            geom_text(data=df_women, aes(y=-value, label=value, color=gender), angle=90, size=3.5, fontface="italic", hjust=1.25) +
            geom_text(aes(y=0, label=year), angle=90, size=4, hjust=0.5, color="white") +
            scale_x_continuous(breaks=seq(min(df$year), max(df$year), by=1)) +
            scale_y_continuous(labels=abs, expand=c(0.4, 0.4)) +
            scale_fill_manual(values=CATEGORYCOLORS) +
            scale_color_manual(values=CATEGORYCOLORS) +
            labs(title=sprintf("%s (%s - %s)", input$trend_population, input$trend_years[1], input$trend_years[2]),
                 x="",
                 y=population) +
            theme(panel.background=element_blank(),
                  axis.text.x=element_blank(),
                  axis.ticks=element_blank())
        return(plot)
    })


    output$occupation_facetplot <- renderPlot({
        # get data from dataframe
        df <- resource.occupation()
        df_men <- df[gender %in% "Men"]
        df_women <- df[gender %in% "Women"]
        percentage_flag <- input$occupation_percentage

        # plotting
        plot <- ggplot(df, aes(x=occupation, y=value, group=gender, color=gender, fill=gender)) +
            facet_grid(age_group ~ race) +
            scale_y_continuous(labels=abs, expand=c(0.4, 0.4)) +
            scale_fill_manual(values=CATEGORYCOLORS) +
            scale_color_manual(values=CATEGORYCOLORS) +
            labs(title="Employment by Occupations (2013)",
                 x="Occupation",
                 y="Employment") +
            theme(panel.background=element_blank(),
                  axis.text.x=element_blank(),
                  axis.ticks=element_blank())
        if (percentage_flag) {  # conditional geom_text label
            plot <- plot +
                geom_text(data=df_men, aes(y=percentage, label=sprintf("%1.1f%%", percentage)), size=3, fontface="italic", hjust=-0.25) +
                geom_text(data=df_women, aes(y=-percentage, label=sprintf("%1.1f%%", percentage)), size=3, fontface="italic", hjust=1.25) +
                geom_bar(data=df_men, aes(y=percentage), stat="identity", color="black") +
                geom_bar(data=df_women, aes(y=-percentage), stat="identity", color="black")
        } else {
            plot <- plot +
                geom_text(data=df_men, aes(y=value, label=value), size=3, fontface="italic", hjust=-0.25) +
                geom_text(data=df_women, aes(y=-value, label=value), size=3, fontface="italic", hjust=1.25) +
                geom_bar(data=df_men, aes(y=value), stat="identity", color="black") +
                geom_bar(data=df_women, aes(y=-value), stat="identity", color="black")
        }
        plot <- plot + coord_flip()  # flip coordinates
        return(plot)
    })


    output$education_barchart <- renderPlot({
        # get data from dataframe
        df <- resource.education()
        category <- input$education_category
        metric <- input$education_metric

        # plotting
        plot <- ggplot(df, aes(x=education, y=value, group=category, color=category, fill=category, ymax=max(value)*1.1)) +
            geom_bar(stat="identity", color="black", position=position_dodge(width=0.6), width=0.5) +
            geom_text(aes(label=value), size=3.5, fontface="italic", hjust=-0.5, position=position_dodge(width=0.6)) +
            scale_y_continuous(labels=comma, expand=c(0.4, 0.4)) +
            scale_color_manual(values=CATEGORYCOLORS) +
            scale_fill_manual(values=CATEGORYCOLORS) +
            labs(title=sprintf("%s (by %s)", metric, category),
                 x="Education Level",
                 y="") +
            theme(panel.background=element_blank(),
                  axis.ticks.y = element_blank())
        plot <- plot + coord_flip()  # flip coordinates
        return(plot)
    })
    
})