task type Worker(Priority_Level : System.Priority; Buffer_Parameter : access Buffer)
   with Priority => Prio is
   entry Fill;
   entry Drain;
end Worker;
