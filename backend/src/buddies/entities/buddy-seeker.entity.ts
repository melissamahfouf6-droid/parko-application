import { Column, CreateDateColumn, Entity, PrimaryGeneratedColumn } from 'typeorm';

@Entity('buddy_seekers')
export class BuddySeeker {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column()
  userId!: string;

  @Column()
  displayName!: string;

  @Column()
  destination!: string;

  @Column()
  destinationKey!: string;

  @Column({ default: 'within_1h' })
  timeWindow!: string;

  @Column({ type: 'int', default: 1 })
  seatsNeeded!: number;

  @CreateDateColumn()
  createdAt!: Date;
}
