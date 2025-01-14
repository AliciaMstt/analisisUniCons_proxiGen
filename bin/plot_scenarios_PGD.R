### This script plots the analyses to compare different ways to incorporate the PDG
### into the Zonation analyses (Fig. 4)

### Libraries
library(ggplot2)
library(dplyr)
library(tidyr)

### Read data

## Read output data generated by the script spatial_analyses_zonationVSproxiesdivgen_all_ms.R
## this shows the area per taxa and proxies of genetic diversity within it 
## considering the Zonation solution for 20% of the country considering only 
## taxa distribution models (no habitat, etc).
sols_summary_spp<-read.csv("../data/comparations_output/sols_summary_spp.txt")

# check data
head(sols_summary_spp)


### Analyses and plots

## Check mean proportion of taxa area and mean proportion of proxies within it, per solution
group_by(sols_summary_spp, Solution) %>% 
  summarise(., mean.prop.sp.area =  mean(Prop_to_AreaSP) , mean.prop.proxies = mean(mean.prop))

### Plots

## Violin plots

# Simpson

filter(sols_summary_spp, Solution!="ENM_sp") %>%
  ggplot(., aes(x=Solution, y=simpson, color=Solution)) + geom_violin() + geom_jitter(size = 0.3) +
  stat_summary(fun.y=mean, geom="point", color="red") +
  theme(axis.text.x = element_blank()) +
  scale_y_continuous(name="Simpson Index")

# Area taxon conserved

filter(sols_summary_spp, Solution!="ENM_sp") %>%
  ggplot(., aes(x=Solution, y=Prop_to_AreaSP, color=Solution)) + geom_violin() + geom_jitter(size = 0.3) +
  stat_summary(fun.y=mean, geom="point", color="red") +
  theme(axis.text.x = element_blank()) +
  scale_y_continuous(name="Proportion of distribution of the taxon conserved")

# Mean prop area proxies by taxon conserved

plot_b <-filter(sols_summary_spp, Solution!="ENM_sp") %>%
  ggplot(., aes(x=Solution, y=mean.prop, color=Solution)) + geom_violin() + geom_jitter(size = 0.3) +
  stat_summary(fun.y=mean, geom="point", color="red") +
  theme(axis.text.x = element_blank()) +
  scale_y_continuous(name="Mean proportion of the area of each proxy conserved by taxon")

plot_b

# Median prop area proxies by taxon ponserved

filter(sols_summary_spp, Solution!="ENM_sp") %>%
  ggplot(., aes(x=Solution, y=median.prop, color=Solution)) + geom_violin() + geom_jitter(size = 0.3) +
  stat_summary(fun.y=mean, geom="point", color="red") +
  theme(axis.text.x = element_blank()) +
  scale_y_continuous(name="Median proportion of the area of each proxy conserved by taxon")

# Median and mean together

filter(sols_summary_spp, Solution!="ENM_sp") %>%
  gather(., SummaryStat, value, -Solution, -c(Richness:Prop_to_AreaSP), -Dist.to.Optimun, -sp) %>%
  ggplot(., aes(x=interaction(SummaryStat, Solution), y=value, color=SummaryStat)) + geom_violin() + geom_jitter(size = 0.1) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


# Proportion of the distribution of the taxon conserved vs MEAN proportion of each proxy conserved by taxon

filter(sols_summary_spp, Solution!="ENM_sp") %>%
  ggplot(., aes(x=Prop_to_AreaSP, y=mean.prop, color=Solution)) + geom_point() +
  scale_x_continuous(name="Proportion of distribution of the taxon conserved") +
  scale_y_continuous(name="Mean proportion of the area of each proxy conserved by taxon")


# Proportion of the distribution of the taxon conserved vs MEADIAN proportion of each proxy conserved by taxon

filter(sols_summary_spp, Solution!="ENM_sp") %>%
  ggplot(., aes(x=Prop_to_AreaSP, y=median.prop, color=Solution)) + geom_point() +
  scale_x_continuous(name="Proportion of distribution of the taxon conserved") +
  scale_y_continuous(name="Median proportion of the area of each proxy conserved by taxon")


## with regression lines

plot_a <-filter(sols_summary_spp, Solution!="ENM_sp") %>%
  # plot points
  ggplot(., aes(x=Prop_to_AreaSP, y=mean.prop, color=Solution)) + geom_point(size=0.7) +
  scale_x_continuous(name="Proportion of taxa distribution (%)") +
  scale_y_continuous(name="Mean proportion of area of proxies of genetic differentiation by taxa (%)", 
                     breaks = seq(0, 1, by = 0.25), expand = c(0, 0)) +
  # plot fitted curve
  geom_smooth(method=loess, aes(fill=Solution)) 
plot_a


### Plot for paper figure (Fig 4):


plot_a <- plot_a +
  # nicer background
  theme_bw()+ theme(panel.border = element_blank(), panel.grid.major = element_blank(),
                    panel.grid.minor = element_blank(), 
                    axis.line = element_line(colour = "black")) +
  
  # nicer legend (fill and color are needed becasue we are plotting both points smooth and points)
  scale_fill_discrete(name = "Scenarios",
                      labels = c("SDM (n=116)", 
                                 "SDM+LZ (n=143)", "SDM+PGD (n=218)",
                                 "SDM*PGD (n=5004)", "SDM and PGD as ADMU (n=117)")) +
  scale_color_discrete(name = "Scenarios",
                       labels = c("SDM (n=116)", 
                                  "SDM+LZ (n=143)", "SDM+PGD (n=218)",
                                  "SDM*PGD (n=5004)", "SDM and PGD as ADMU (n=117)")) +
  theme(legend.position = c(.99, 0.01), legend.justification = c("right", "bottom")) +
  
  # title
  labs(title="a)") +

  # larger text
  theme(
  plot.title = element_text(size=14, face="bold"),
  axis.title = element_text(size=14),
  axis.text = element_text(size=13),
  legend.text = element_text(size=13),
  legend.title = element_text(size=13, face="bold"))

plot_a

plot_b <- plot_b +
  # nicer background
  theme_bw()+ theme(panel.border = element_blank(), panel.grid.major = element_blank(),
                    panel.grid.minor = element_blank(), 
                    axis.line = element_line(colour = "black")) +
  # no legend 
  theme(legend.position = "none") +
  
  # nicar x names
  scale_x_discrete(name="Scenarios",
                   labels=c("SDM", 
                            "SDM+LZ", "SDM+PGD",
                            "SDM*PGD", "as ADMU")) +
  # title
  labs(title="b)") +
  
  # larger text
  theme(
    plot.title = element_text(size=14, face="bold"),
    axis.title = element_text(size=14),
    axis.text = element_text(size=13))

plot_b  

## Plot Together


# Multiple plot function taken from http://www.cookbook-r.com/Graphs/Multiple_graphs_on_one_page_(ggplot2)/
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}

multiplot(plot_a, plot_b, cols=2)

## Supplementary analysis suggested during review:

# Read IUCN category per taxa
iucn<-read.csv("../data/spatial/Zonation_final_solutions/IUCN_threat_category.csv")

# change names to fit sols_summary_spp names
iucn<-mutate(iucn, Nombre_=gsub("_", " ", iucn$Nombre_)) %>%

# keep only needed variables
select(.,-Taxa) 

# add iucn data to Zonation solutions
sols_summary_spp<-left_join(sols_summary_spp, iucn, by =c("sp" = "Nombre_")) %>%

# Get Genus
separate(col=sp, 
         into=c("Genus", "Species"), 
         sep=" ", extra="merge", remove=FALSE)

# For the SDM*PGD curve of Fig 4a, get which taxa have less than 60% PGD represented
filter(sols_summary_spp, Solution=="Scenario_SDM_vs_PGD", mean.prop<0.60) %>% 
  select(., mean.prop, Area, IUCN.threat.category, sp)

# For the SDM*PGD curve of Fig 4a, get which taxa have >90% PGD represented
filter(sols_summary_spp, Solution=="Scenario_SDM_vs_PGD", mean.prop>0.90) %>% 
  select(., mean.prop, Area, IUCN.threat.category, sp)


# Examine if there is a pattern on which have more or less PGD represented

# By genus
plot_genus <-filter(sols_summary_spp, Solution=="Scenario_SDM_vs_PGD") %>%
  # plot points
  ggplot(., aes(x=Prop_to_AreaSP, y=mean.prop, color=Genus)) + geom_point(size=1.1) +
  scale_x_continuous(name="Proportion of taxa distribution (%)") +
  scale_y_continuous(name="Mean proportion of area of proxies of genetic differentiation by taxa (%)", 
                     breaks = seq(0, 1, by = 0.25), expand = c(0, 0)) +
  theme_bw() 
plot_genus

# by IUCN
iucn.cols<-c("#D81E05", "#FC7F3F", "#F9E814", "#CCE226", "#60C659", "#D1D1C6") # respectively for "CR", "EN", "VU", "NT", "LC", "DD"

plot_iucn <-filter(sols_summary_spp, Solution=="Scenario_SDM_vs_PGD") %>%
  # plot points
  ggplot(., aes(x=Prop_to_AreaSP, y=mean.prop, color=IUCN.threat.category)) + geom_point(size=1.1) +
  scale_x_continuous(name="Proportion of taxa distribution (%)") +
  scale_y_continuous(name="Mean proportion of area of proxies of genetic differentiation by taxa (%)", 
                     breaks = seq(0, 1, by = 0.25), expand = c(0, 0)) +
  scale_color_manual(values= iucn.cols,
                     breaks= c("CR", "EN", "VU", "NT", "LC", "DD"),
                     name= "Threat category") +
  theme_bw()+ labs(title="a)")
plot_iucn

# plot by area
plot_area <-filter(sols_summary_spp, Solution=="Scenario_SDM_vs_PGD") %>%
  # plot points
  ggplot(., aes(x=Prop_to_AreaSP, y=mean.prop, color=Area)) + geom_point(size=1.1) +
  scale_x_continuous(name="Proportion of taxa distribution (%)") +
  scale_y_continuous(name="Mean proportion of area of proxies of genetic differentiation by taxa (%)", 
                     breaks = seq(0, 1, by = 0.25), expand = c(0, 0)) +
  theme_bw() + labs(title="b)")
plot_area

multiplot(plot_iucn, plot_area, cols=1)


# Get session info
sessionInfo()
