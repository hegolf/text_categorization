library(ggplot2)
library(gridExtra)

############# qplot: Quick Plot ###############
# http://ggplot2.org/book/qplot.pdf
# http://ggplot2.org/book/toc.pdf
# Use data set diamonds available in ggplot

set.seed(1410)  # Make the sample reproducible
dsmall <- diamonds[sample(nrow(diamonds), 100), ]

qplot(data = diamonds, carat, price)

# Looks exponential --> transform with log (to see linear relation)
qplot(data = diamonds, log(carat), log(price))

qplot(carat, x * y * z, data = diamonds)

# With colors
qplot(carat, price, data = dsmall, colour = color) # because df has a col named color
qplot(carat, price, data = dsmall, shape = cut) # because df has a col named cut

# manually set the aesthetics using I(), e.g., colour = I("red")
# or size = I(2). 
qplot(carat, price, data = dsmall, colour = I("red")) # because df has a col named color


# Use semitransparent colour with alpha aestic with val between 0 and 1
par(mfrow = c(3, 2))

p1 <- qplot(carat, price, data = dsmall, alpha = I(1/10))
p2 <- qplot(carat, price, data = dsmall, alpha = I(1/100))
p3 <- qplot(carat, price, data = dsmall, alpha = I(1/200))

grid.arrange(p1, p2, p3, nrow = 3, ncol =2, top = "Diamonds")
# Different types of aesthetic attributes work better with different types of
# variables. For example, colour and shape work well with categorical variables,
# while size works better with continuous variables. The amount of data also
# makes a difference: if there is a lot of data, like in the plots above, it can
# be hard to distinguish the different groups

# Plot geoms

# Adding a smoother
p4 <- qplot(carat, price, data = dsmall, geom = c("point", "smooth"))
p5 <- qplot(carat, price, data = diamonds, geom = c("point", "smooth"))
p6 <- qplot(log(carat), log(price), data = diamonds, geom = c("point", "smooth"))

grid.arrange(p4, p5, p6)


#############################################################################

# Gamle eksempler
# Plot result
ggplot(data = df.null.xpid.15, aes(y = df.null.xpid.15$prop, x = c(0:43), color = "No_XPID")) +
  geom_line(alpha = 0.8) +
  geom_line(aes(y = df.xpid.15$prop, color = "With_XPID")) +
  scale_color_manual("",
                     breaks = c("No_XPID", "With_XPID"),
                     values = c("darkred", "darkgreen")) +
  scale_x_continuous(breaks = round(seq(0, 43, by = 2),1)) +
  ggtitle("15. January, Account 28: Visitors with and without XPIDs") +
  xlab("Days since last used") + 
  ylab("Proportion %") 

ggplot(data = df.null.xpid.15, aes(y = df.null.xpid.15$cum, x = c(0:43), color = "No_XPID")) +
  geom_line(alpha = 0.8) +
  geom_line(aes(y = df.xpid.15$cum, color = "With_XPID")) +
  scale_color_manual("",
                     breaks = c("No_XPID", "With_XPID"),
                     values = c("darkred", "darkgreen")) +
  scale_x_continuous(breaks = round(seq(0, 43, by = 5),1)) +
  scale_y_continuous(breaks = round(seq(0, 1, by = 0.1),1)) +
  ggtitle("15. January, Account 28: Visitors with and without XPIDs (cumulative)") +
  xlab("Days since last used") + 
  ylab("Proportion")

# Plot result
ggplot(data = df.null.xpid.26, aes(y = df.null.xpid.26$prop, x = c(0:43), color = "No_XPID")) +
  geom_line(alpha = 0.8) +
  geom_line(aes(y = df.xpid.26$prop, color = "With_XPID")) +
  scale_color_manual("",
                     breaks = c("No_XPID", "With_XPID"),
                     values = c("darkred", "darkgreen")) +
  scale_x_continuous(breaks = round(seq(0, 43, by = 2),1)) +
  ggtitle("12. January, Account 26: Visitors with and without XPIDs") +
  xlab("Days since last used") + 
  ylab("Proportion")

# Cumulative 
ggplot(data = df.null.xpid.26, aes(y = df.null.xpid.26$cum, x = c(0:43), color = "No_XPID")) +
  geom_line(alpha = 0.8) +
  geom_line(aes(y = df.xpid.26$cum, color = "With_XPID")) +
  scale_color_manual("",
                     breaks = c("No_XPID", "With_XPID"),
                     values = c("darkred", "darkgreen")) +
  scale_x_continuous(breaks = round(seq(0, 43, by = 5),1)) +
  scale_y_continuous(breaks = round(seq(0, 1, by = 0.1),1)) +
  ggtitle("12. January, Account 26: Visitors with and without XPIDs (cumulative)") +
  xlab("Days since last used") + 
  ylab("Proportion") 
###########################################
