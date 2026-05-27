import { Column, CreateDateColumn, Entity, PrimaryGeneratedColumn } from 'typeorm';

@Entity('availability_waitlist')
export class AvailabilityWaitlist {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column()
  userId!: string;

  @Column()
  lotId!: string;

  @CreateDateColumn()
  createdAt!: Date;
}
